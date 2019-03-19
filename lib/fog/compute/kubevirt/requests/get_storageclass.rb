module Fog
  module Compute
    class Kubevirt
      class Real
        def get_storageclass(name)
          Storageclass.parse object_to_hash(kube_storage_client.get_storage_class(name))
        end
      end

      class Mock
        def get_storage_class(name)
        end
      end
    end
  end
end