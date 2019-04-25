module Fog
  module Kubevirt
    module Utils
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
    end
  end
end