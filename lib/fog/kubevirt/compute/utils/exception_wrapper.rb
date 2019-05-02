module Fog
  module Kubevirt
    module Utils
      class ExceptionWrapper
        def initialize(client, version, log)
          @client = client
          @version = version
          @log = log
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
          @log.warn(e)
          if e.error_code == 409
            raise ::Fog::Kubevirt::Errors::AlreadyExistsError, e
          elsif e.error_code == 404
            raise ::Fog::Kubevirt::Errors::NotFoundError, e
          else 
            raise ::Fog::Kubevirt::Errors::ClientError, e
          end
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