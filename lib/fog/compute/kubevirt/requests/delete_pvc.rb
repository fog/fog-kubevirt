module Fog
  module Compute
    class Kubevirt
      class Real
        def delete_pvc(name)
          kube_client.delete_persistent_volume_claim(name, namespace)
        end
      end

      class Mock
        def delete_pvc(name)
        end
      end
    end
  end
end