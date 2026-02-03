require 'recursive_open_struct'

module Fog
  module Kubevirt
    class Compute
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
          if _filters == {}
            EntityCollection.new("StorageClass", "775504", [{
              :name=>"local-storage",
              :resource_version=>"775504",
              :uid=>"c930bca9-5471-11e9-9132-525400c5a686",
              :parameters=>nil,
              :mount_options=>nil,
              :provisioner=>"kubernetes.io/no-provisioner",
              :reclaim_policy=>"Delete",
              :volume_binding_mode=>"WaitForFirstConsumer"
            }])
          end
        end
      end
    end
  end
end
