module Fog
  module Compute
    class Kubevirt
      class Real
        def create_pvc(pvc)
          kube_client.create_persistent_volume_claim(pvc)
        rescue Kubeclient::HttpError
          raise ::Fog::Kubevirt::Errors::AlreadyExistsError
        end
      end

      class Mock
        def create_pvc(attrs); end
      end
    end
  end
end
