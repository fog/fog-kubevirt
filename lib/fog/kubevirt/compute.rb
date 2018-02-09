require 'fog/ovirt/core'

module Fog
  module Compute
    class Kubevirt < Fog::Service
      requires   :kubevirt_token
      recognizes :kubevirt_host, :kubevirt_port

      model_path 'fog/kubevirt/models/compute'

      model      :template
      collection :templates
      model      :volume
      collection :volumes

      request_path 'fog/kubevirt/requests/compute'

      request :destroy_vm
      request :create_vm

      module Shared
	# converts kubeclient objects info hash for fog to consume
        def to_hash(object)
          result = object
          case result
          when OpenStruct
            result = result.marshal_dump
            result.each do |k, v|
              result[k] = to_hash(v)
            end
          when Array
            result = result.map { |v| to_hash(v) }
          end
          result
        end
      end

      class Real
        include Shared

	def initialize(options={})
	  require 'kubeclient'

	  token = options[:kubevirt_token]
	  host  = options[:kubevirt_host]
	  port  = options[:kubevirt_port]

          # TODO use kubeclient
	  @client = nil
        end

        private

        def client
          @client
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
