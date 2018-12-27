module Fog
  module Compute
    class Kubevirt
      class Real
        def get_pvc(name)
          Pvc.parse object_to_hash(kube_client.get_persistent_volume_claim(name, @namespace))
        end
      end

      class Mock
        def get_pvc(name)
        end
      end
    end
  end
end