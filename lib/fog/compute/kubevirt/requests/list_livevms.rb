module Fog
  module Compute
    class Kubevirt
      class Real
        def list_livevms(_filters = {})
          vms = kubevirt_client.get_virtual_machines(namespace: @namespace)
          entities = vms.map do |kubevirt_obj|
            Livevm.parse object_to_hash(kubevirt_obj)
          end
          EntityCollection.new(vms.kind, vms.resourceVersion, entities)
        end
      end

      class Mock
        # TODO provide implementation
        def list_livevms(_filters = {})
        end
      end
    end
  end
end
