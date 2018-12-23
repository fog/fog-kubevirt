require 'recursive_open_struct'

module Fog
  module Compute
    class Kubevirt
      class Real
        def list_volumes(_filters = {})
          volumes = kube_client.get_persistent_volumes()
          entities = volumes.map do |kubevirt_obj|
            Volume.parse object_to_hash(kubevirt_obj)
          end
          EntityCollection.new(volumes.kind, volumes.resourceVersion, entities)
        end
      end

      class Mock
        def list_volumes(_filters = {})
        end
      end
    end
  end
end
