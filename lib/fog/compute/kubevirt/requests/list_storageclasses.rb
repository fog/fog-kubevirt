require 'recursive_open_struct'

module Fog
  module Compute
    class Kubevirt
      class Real
        def list_storageclasses(_filters = {})
          storageclasses = kube_storage_client.get_storage_classes
          entities = storageclasses.map do |kubevirt_obj|
            Storageclass.parse object_to_hash(kubevirt_obj)
          end
          EntityCollection.new(storageclasses.kind, storageclasses.resourceVersion, entities)
        end
      end

      class Mock
        def list_storageclasses(_filters = {})
        end
      end
    end
  end
end
