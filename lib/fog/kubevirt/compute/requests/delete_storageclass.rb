module Fog
  module Kubevirt
    class Compute
      class Real
        def delete_storageclass(name)
          kube_storage_client.delete_storage_class(name)
        end
      end

      class Mock
        def delete_storage_class(name)
        end
      end
    end
  end
end