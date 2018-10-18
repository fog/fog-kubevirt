module Fog
  module Compute
    class Kubevirt
      class Real
        def create_service(srv)
          kube_client.create_service(srv)
        rescue ::Fog::Kubevirt::Errors::ClientError => err
          log.warn(err)
          raise ::Fog::Kubevirt::Errors::AlreadyExistsError
        end
      end

      class Mock
        def create_service(srv); end
      end
    end
  end
end