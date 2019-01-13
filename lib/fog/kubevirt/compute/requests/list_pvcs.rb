require 'recursive_open_struct'

module Fog
  module Kubevirt
    class Compute
      class Real
        def list_pvcs(_filters = {})
          pvcs = kube_client.get_persistent_volume_claims(namespace: @namespace)
          entities = pvcs.map do |kubevirt_obj|
            Pvc.parse object_to_hash(kubevirt_obj)
          end
          EntityCollection.new(pvcs.kind, pvcs.resourceVersion, entities)
        end
      end

      class Mock
        def list_pvcs(_filters = {})
        end
      end
    end
  end
end
