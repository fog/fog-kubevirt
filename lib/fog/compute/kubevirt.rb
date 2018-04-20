require "fog/core"

module Fog
  module Compute
    class Kubevirt < Fog::Service
      requires   :kubevirt_token
      recognizes :kubevirt_hostname, :kubevirt_port, :kubevirt_namespace

      model_path 'fog/compute/kubevirt/models'
      model      :livevm
      collection :livevms
      model      :node
      collection :nodes
      model      :offlinevm
      collection :offlinevms
      model      :template
      collection :templates
      model      :volume
      collection :volumes

      request_path 'fog/compute/kubevirt/requests'

      request :create_vm
      request :create_offlinevm
      request :create_pvc
      request :delete_livevm
      request :delete_offlinevm
      request :get_livevm
      request :get_node
      request :get_offlinevm
      request :get_template
      request :list_livevms
      request :list_nodes
      request :list_offlinevms
      request :list_templates
      request :update_offlinevm

      module Shared
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
        # The API version and group of the Kubernetes core:
        #
        CORE_GROUP = ''.freeze
        CORE_VERSION = 'v1'.freeze

        #
        # The API version and group of KubeVirt:
        #
        KUBEVIRT_GROUP = 'kubevirt.io'.freeze
        KUBEVIRT_VERSION = 'v1alpha1'.freeze

        def initialize(options={})
          require 'kubeclient'

          @kubevirt_token = options[:kubevirt_token]
          @host  = options[:kubevirt_hostname]
          @port  = options[:kubevirt_port]

          @namespace = options[:kubevirt_namespace] || 'default'

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

          # Kubeclient needs different client objects for different API groups. We will keep in this hash the
          # client objects, indexed by API path/version.
          @clients = {}
        end

        def virt_supported?
          virt_enabled = false

          begin
            api_versions = kubevirt_client.api["versions"]
            api_versions.each do |ver|
              if ver["groupVersion"]&.start_with?(KUBEVIRT_GROUP)
                virt_enabled = true
              end
            end
          rescue => err
            # we failed to communicate or to evaluate the version format
            $log.warn("Failed to detect kubevirt on provider with error: #{err.message}")
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
        end

        #
        # Returns a watcher for nodes.
        #
        # @param opts [Hash] A hash with options for the watcher.
        # @return [WatchWrapper] The watcher.
        #
        def watch_nodes(opts = {})
          mapper = Proc.new do |notice|
            node = OpenStruct.new(Node.parse(notice.object))
            populate_notice_attributes(node, notice)
            node
          end
          watch = kube_client.watch_nodes(opts)

          WatchWrapper.new(watch, mapper)
        end

        #
        # Returns a watcher for offline virtual machines.
        #
        # @param opts [Hash] A hash with options for the watcher.
        # @return [WatchWrapper] The watcher.
        #
        def watch_offline_vms(opts = {})
          mapper = Proc.new do |notice|
            offlinevm = OpenStruct.new(Offlinevm.parse(notice.object))
            populate_notice_attributes(offlinevm, notice)
            offlinevm
          end
          watch = kubevirt_client.watch_offline_virtual_machines(opts)

          WatchWrapper.new(watch, mapper)
        end

        #
        # Returns a watcher for live virtual machines.
        #
        # @param opts [Hash] A hash with options for the watcher.
        # @return [WatchWrapper] The watcher.
        #
        def watch_live_vms(opts = {})
          mapper = Proc.new do |notice|
            livevm = OpenStruct.new(Livevm.parse(notice.object))
            populate_notice_attributes(livevm, notice)
            livevm
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
            template = OpenStruct.new(Template.parse(notice.object))
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
          @clients[key] = client

          # Return the client:
          client
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
