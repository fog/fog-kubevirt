module Fog
  module Compute
    class Kubevirt < Fog::Service
      requires   :kubevirt_token
      recognizes :kubevirt_hostname, :kubevirt_port

      model_path 'fog/compute/kubevirt/models'
      model      :livevm
      collection :livevms
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
      request :destroy_vm
      request :get_livevm
      request :get_offlinevm
      request :get_template
      request :list_livevms
      request :list_offlinevms
      request :list_templates
      request :update_offlinevm

      module Shared
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
      end

      class Real
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

          @client = kubevirt_client()

          # TODO expect a specific token
          @oc_client = openshift_client()
          @kube_client = kube_client()
        end

        private

        def client
          @client
        end

        def oc_client
          @oc_client
        end

        def kube_client
          @kubeclient
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
