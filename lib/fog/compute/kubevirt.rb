require 'delegate'

require "fog/core"

module Fog
  module Compute
    class Kubevirt < Fog::Service
      requires   :kubevirt_token
      recognizes :kubevirt_hostname, :kubevirt_port, :kubevirt_namespace, \
                 :kubevirt_log, :kubevirt_verify_ssl, :kubevirt_ca_cert

      model_path 'fog/compute/kubevirt/models'
      model      :vminstance
      collection :vminstances
      model      :node
      collection :nodes
      model      :vm
      collection :vms
      model      :server
      collection :servers
      model      :service
      collection :services
      model      :template
      collection :templates
      model      :volume
      collection :volumes

      request_path 'fog/compute/kubevirt/requests'

      request :create_vm
      request :create_vminstance
      request :create_pvc
      request :create_service
      request :delete_service
      request :delete_vminstance
      request :delete_vm
      request :get_vminstance
      request :get_node
      request :get_vm
      request :get_server
      request :get_service
      request :get_template
      request :list_vminstances
      request :list_nodes
      request :list_vms
      request :list_servers
      request :list_services
      request :list_templates
      request :update_vm

      module Shared

        class EntityCollection < DelegateClass(Array)
          attr_reader :kind, :resource_version

          def initialize(kind, resource_version, entities)
            @kind = kind
            @resource_version = resource_version
            super(entities)
          end
        end

        class ExceptionWrapper
          def initialize(client)
            @client = client
          end

          def method_missing(symbol, *args)
            super unless @client.respond_to?(symbol)

            if block_given?
              @client.__send__(symbol, *args) do |*block_args|
                yield(*block_args)
              end
            else
              @client.__send__(symbol, *args)
            end
          rescue KubeException => e
            raise ::Fog::Kubevirt::Errors::ClientError, e
          end

          def respond_to_missing?(method_name, include_private = false)
            @client.respond_to?(symbol, include_all) || super
          end
        end

        #
        # Label name which identifies operation system information
        #
        OS_LABEL = 'kubevirt.io/os'.freeze
        OS_LABEL_SYMBOL = :'kubevirt.io/os'

        # converts kubeclient objects into hash for fog to consume
        def object_to_hash(object)
          result = object
          case result
          when OpenStruct
            result = result.marshal_dump
            result.each do |k, v|
              result[k] = object_to_hash(v)
            end
          when Array
            result = result.map { |v| object_to_hash(v) }
          end

          result
        end

        # Copied from rails:
        # File activesupport/lib/active_support/core_ext/hash/deep_merge.rb, line 21
        # The method was changed to look like this in v4.0.0 of rails
        def deep_merge!(source_hash, other_hash, &block)
          other_hash.each_pair do |current_key, other_value|
            this_value = source_hash[current_key]

            source_hash[current_key] = if this_value.is_a?(Hash) && other_value.is_a?(Hash)
                                         this_value = deep_merge!(this_value, other_value, &block)
                                       else
                                         if block_given? && key?(current_key)
                                           block.call(current_key, this_value, other_value)
                                         else
                                           other_value
                                         end
                                       end
          end

          source_hash
        end
      end

      class Real
        require "ostruct"
        include Shared

        #
        # The API version and group of KubeVirt:
        #
        KUBEVIRT_GROUP = 'kubevirt.io'.freeze
        KUBEVIRT_VERSION = 'v1alpha2'.freeze
        KUBEVIRT_VERSION_LABEL = KUBEVIRT_GROUP + '/' + KUBEVIRT_VERSION

        #
        # The API version and group of the Kubernetes core:
        #
        CORE_GROUP = ''.freeze
        CORE_VERSION = 'v1'.freeze

        def initialize(options={})
          require 'kubeclient'

          @kubevirt_token = options[:kubevirt_token]
          @host = options[:kubevirt_hostname]
          @port = options[:kubevirt_port]

          @log = options[:kubevirt_log]
          @log ||= ::Logger.new(STDOUT)

          @namespace = options[:kubevirt_namespace] || 'default'
          @opts = {
            :ssl_options  => obtain_ssl_options(options),
            :auth_options => {
              :bearer_token => @kubevirt_token
            }
          }

          # Kubeclient needs different client objects for different API groups. We will keep in this hash the
          # client objects, indexed by API path/version.
          @clients = {}
        end

        def virt_supported?
          virt_enabled = false

          begin
            virt_enabled = kubevirt_client.api["versions"].any? { |ver| ver["groupVersion"]&.start_with?(KUBEVIRT_GROUP) }
          rescue => err
            # we failed to communicate or to evaluate the version format
            @log.warn("Failed to detect kubevirt on provider with error: #{err.message}")
          end

          virt_enabled
        end

        def valid?
          kube_client.api_valid?
        end

        class WatchWrapper

          def initialize(watch, mapper)
            @watch = watch
            @mapper = mapper
          end

          def each
            @watch.each do |notice|
              yield @mapper.call(notice)
            end
          end

          def finish
            @watch.finish
          end
        end

        #
        # Returns a watcher for nodes.
        #
        # @param opts [Hash] A hash with options for the watcher.
        # @return [WatchWrapper] The watcher.
        #
        def watch_nodes(opts = {})
          mapper = Proc.new do |notice|
            node = OpenStruct.new(Node.parse(notice.object)) if notice.object.kind == 'Node'
            node ||= OpenStruct.new

            populate_notice_attributes(node, notice)
            node
          end
          watch = kube_client.watch_nodes(opts)

          WatchWrapper.new(watch, mapper)
        end

        #
        # Returns a watcher for virtual machines.
        #
        # @param opts [Hash] A hash with options for the watcher.
        # @return [WatchWrapper] The watcher.
        #
        def watch_vms(opts = {})
          mapper = Proc.new do |notice|
            vm = OpenStruct.new(Vm.parse(notice.object)) if notice.object.kind == 'VirtualMachine'
            vm ||= OpenStruct.new

            populate_notice_attributes(vm, notice)
            vm
          end
          watch = kubevirt_client.watch_virtual_machines(opts)

          WatchWrapper.new(watch, mapper)
        end

        #
        # Returns a watcher for virtual machine instances.
        #
        # @param opts [Hash] A hash with options for the watcher.
        # @return [WatchWrapper] The watcher.
        #
        def watch_vminstances(opts = {})
          mapper = Proc.new do |notice|
            vminstance = OpenStruct.new(Vminstance.parse(notice.object)) if notice.object.kind == 'VirtualMachineInstance'
            vminstance ||= OpenStruct.new

            populate_notice_attributes(vminstance, notice)
            vminstance
          end
          watch = kubevirt_client.watch_virtual_machines(opts)

          WatchWrapper.new(watch, mapper)
        end

        #
        # Returns a watcher for templates.
        #
        # @param opts [Hash] A hash with options for the watcher.
        # @return [WatchWrapper] The watcher.
        #
        def watch_templates(opts = {})
          mapper = Proc.new do |notice|
            template = OpenStruct.new(Template.parse(notice.object)) if notice.object.kind == 'Template'
            template ||= OpenStruct.new

            populate_notice_attributes(template, notice)
            template
          end
          watch = openshift_client.watch_templates(opts)

          WatchWrapper.new(watch, mapper)
        end

        #
        # Calculates the URL of the SPICE proxy server.
        #
        # @return [String] The URL of the spice proxy server.
        #
        def spice_proxy_url
          service = kube_client.get_service('spice-proxy', @namespace)
          host = service.spec.externalIPs.first
          port = service.spec.ports.first.port
          url = URI::Generic.build(
            :scheme => 'http',
            :host   => host,
            :port   => port,
          )
          url.to_s
        end

        def namespace
          @namespace
        end

        private


        #
        # Populates required notice attributes
        #
        # @param object entity to populate
        # @param notice the source of the data to populate from
        def populate_notice_attributes(object, notice)
          object.metadata = notice.object.metadata
          object.type = notice.type
          object.code = notice.object.code
          object.kind = notice.object.kind
        end

        #
        # Lazily creates the a client for the given Kubernetes API path and version.
        #
        # @param path [String] The Kubernetes API path.
        # @param version [String] The Kubernetes API version.
        # @return [Kubeclient::Client] The client for the given path and version.
        #
        def create_client(path, version)
          # Return the client immediately if it has been created before:
          key = path + '/' + version
          client = @clients[key]
          return client if client

          # Create the client and save it:
          url = URI::Generic.build(
            :scheme => 'https',
            :host   => @host,
            :port   => @port,
            :path   => path
          )
          client = Kubeclient::Client.new(
            url.to_s,
            version,
            @opts
          )
          wrapped_client = ExceptionWrapper.new(client)
          @clients[key] = wrapped_client

          # Return the client:
          wrapped_client
        end

        def openshift_client
          create_client('/oapi', CORE_VERSION)
        end

        def kube_client
          create_client('/api', CORE_VERSION)
        end

        def kubevirt_client
          create_client('/apis/' + KUBEVIRT_GROUP, KUBEVIRT_VERSION)
        end

        def log
          @log
        end

        #
        # Prepare the TLS and authentication options that will be used for the
        # standard Kubernetes API and also for the KubeVirt extension
        #
        # @param options [Hash] a hash with connection options
        #
        def obtain_ssl_options(options)
          verify_ssl = options[:kubevirt_verify_ssl]
          if verify_ssl == true
            ca = options[:kubevirt_ca_cert] || ""
            ca = IO.read(ca) if File.file?(ca)
            certs = ca.split(/(?=-----BEGIN)/).reject(&:empty?).collect do |pem|
              OpenSSL::X509::Certificate.new(pem)
            end

            cert_store = OpenSSL::X509::Store.new
            certs.each do |cert|
              cert_store.add_cert(cert)
            end

            ssl_options = {
              :verify_ssl => OpenSSL::SSL::VERIFY_PEER,
              :cert_store => cert_store
            }
          elsif verify_ssl == false || verify_ssl.to_s.empty?
            ssl_options = {
              :verify_ssl => OpenSSL::SSL::VERIFY_NONE
            }
          else
            ssl_options = {
              :verify_ssl => verify_ssl
            }
          end
        end
      end

      class Mock
        include Shared

        def initialize(options={})
        end

        private

        def client
          return @client if defined?(@client)
        end

        # TODO provide mocking
      end
    end
  end
end
