module Fog
  module Kubevirt
    class Compute
      class Real
        def get_persistentvolume(name)
          Persistentvolume.parse object_to_hash(kube_client.get_persistent_volume(name))
        end
      end

      class Mock
        def get_persistentvolume(name)
        end
      end
    end
  end
end