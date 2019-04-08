module Fog
  module Kubevirt
    class Compute
      class Real
        def create_pvc(pvc)
          kube_client.create_persistent_volume_claim(pvc)
        rescue ::Fog::Kubevirt::Errors::ClientError => err
          log.warn(err)
          raise ::Fog::Kubevirt::Errors::AlreadyExistsError
        end
      end

      class Mock
        def create_pvc(attrs); end
      end
    end
  end
end
