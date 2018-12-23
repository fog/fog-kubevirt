module Fog
  module Compute
    class Kubevirt
      class Real
        def get_volume(name)
          Volume.parse object_to_hash(kube_client.get_persistent_volume(name))
        end
      end

      class Mock
        def get_volume(name)
        end
      end
    end
  end
end