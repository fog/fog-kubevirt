require 'delegate'
require 'json'
require 'rest-client'

require "fog/core"

module Fog
  module Kubevirt
    class Compute < Fog::Service
      recognizes :kubevirt_token, :kubevirt_hostname, :kubevirt_port, :kubevirt_namespace, :kubevirt_log

      model_path 'fog/kubevirt/compute/models'
      model      :vminstance
      collection :vminstances
      model      :networkattachmentdef
      collection :networkattachmentdefs
      model      :node
      collection :nodes
      model      :vm
      collection :vms
      model      :persistentvolume
      collection :persistentvolumes
      model      :pvc
      collection :pvcs
      model      :server
      collection :servers
      model      :service
      collection :services
      model      :storageclass
      collection :storageclasses
      model      :template
      collection :templates
      model      :volume
      collection :volumes

      request_path 'fog/kubevirt/compute/requests'
      request :create_networkattachmentdef
      request :create_vm
      request :create_vminstance
      request :create_persistentvolume
      request :create_pvc
      request :create_service
      request :create_storageclass
      request :delete_networkattachmentdef
      request :delete_persistentvolume
      request :delete_pvc
      request :delete_service
      request :delete_storageclass
      request :delete_vminstance
      request :delete_vm
      request :get_vminstance
      request :get_networkattachmentdef
      request :get_node
      request :get_persistentvolume
      request :get_pvc
      request :get_vm
      request :get_server
      request :get_service
      request :get_storageclass
      request :get_template
      request :list_vminstances
      request :list_nodes
      request :list_networkattachmentdefs
      request :list_vms
      request :list_persistentvolumes
      request :list_pvcs
      request :list_servers
      request :list_services
      request :list_storageclasses
      request :list_templates
      request :list_volumes
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
          def initialize(client, version)
            @client = client
            @version = version
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

          def version
            @version
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
        # The API group of the Kubernetes core:
        #
        CORE_GROUP = ''.freeze

        #
        # The API group of KubeVirt:
        #
        KUBEVIRT_GROUP = 'kubevirt.io'.freeze

        #
        # The API group of the Kubernetes network extention:
        #
        NETWORK_GROUP = 'k8s.cni.cncf.io'.freeze

        #
        # The API group of the Kubernetes network extention:
        #
        STORAGE_GROUP = 'storage.k8s.io'.freeze

        def initialize(options={})
          require 'kubeclient'

          @kubevirt_token = options[:kubevirt_token]
          @host = options[:kubevirt_hostname]
          @port = options[:kubevirt_port]

          @log = options[:kubevirt_log]
          @log ||= ::Logger.new(STDOUT)

          @namespace = options[:kubevirt_namespace] || 'default'

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
          watch = kubevirt_client.watch_virtual_machine_instances(opts)

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
        # Lazily creates the a client for the given Kubernetes API path.
        #
        # @param path [String] The Kubernetes API path.
        # @return [Kubeclient::Client] The client for the given path.
        #
        def create_client(path)
          url = URI::Generic.build(
            :scheme => 'https',
            :host   => @host,
            :port   => @port,
            :path   => path
          )

          if @kubevirt_token.to_s.empty?
            create_client_from_config(path)
          else
            create_client_from_token(url)
          end
        end

        def create_client_from_token(url)
          # Prepare the TLS and authentication options that will be used for the standard Kubernetes API
          # and also for the KubeVirt extension:
          @opts = {
            :ssl_options  => {
              :verify_ssl => OpenSSL::SSL::VERIFY_NONE,
            },
            :auth_options => {
              :bearer_token => @kubevirt_token
            }
          }
          version = detect_version(url.to_s, @opts[:ssl_options])
          key = url.path + '/' + version

          client = check_client(key)
          return client if client

          client = Kubeclient::Client.new(
            url.to_s,
            version,
            @opts
          )

          wrap_client(client, version, key)
        end

        def create_client_from_config(path)
          config = Kubeclient::Config.read(ENV['KUBECONFIG'] || ENV['HOME']+'/.kube/config')
          context = config.context
          url = context.api_endpoint
          version = detect_version(url + path, context.ssl_options)
          key = path + '/' + version

          client = check_client(key)
          return client if client

          client = Kubeclient::Client.new(
            url + path,
            version,
            ssl_options: context.ssl_options,
            auth_options: context.auth_options
          )

          wrap_client(client, version, key)
        end

        def check_client(key)
          @clients[key]
        end

        def wrap_client(client, version, key)
          wrapped_client = ExceptionWrapper.new(client, version)
          @clients[key] = wrapped_client

          wrapped_client
        end

        def detect_version(url, ssl_options)
          options = {
            ssl_ca_file: ssl_options[:ca_file],
            ssl_cert_store: ssl_options[:cert_store],
            verify_ssl: ssl_options[:verify_ssl],
            ssl_client_cert: ssl_options[:client_cert],
            ssl_client_key: ssl_options[:client_key],
          }

          begin
            response = ::JSON.parse(RestClient::Resource.new(url, options).get)
          rescue => e
            raise ::Fog::Kubevirt::Errors::ClientError, e
          end

          # version detected based on
          # https://github.com/kubernetes-incubator/apiserver-builder/blob/master/docs/concepts/aggregation.md#viewing-discovery-information
          preferredVersion = response["preferredVersion"]
          return preferredVersion["version"] if preferredVersion
          response["versions"][0]
        end

        def openshift_client
          create_client('/oapi')
        end

        def kube_client
          create_client('/api')
        end

        def kubevirt_client
          create_client('/apis/' + KUBEVIRT_GROUP)
        end

        def kube_net_client
          create_client('/apis/' + NETWORK_GROUP)
        end

        def kube_storage_client
          create_client('/apis/' + STORAGE_GROUP)
        end

        def log
          @log
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
