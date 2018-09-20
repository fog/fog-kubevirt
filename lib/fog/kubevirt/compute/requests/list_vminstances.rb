module Fog
  module Kubevirt
    class Compute
      class Real
        def list_vminstances(_filters = {})
          vminstances = kubevirt_client.get_virtual_machine_instances(namespace: @namespace)
          entities = vminstances.map do |kubevirt_obj|
            Vminstance.parse object_to_hash(kubevirt_obj)
          end
          EntityCollection.new(vminstances.kind, vminstances.resourceVersion, entities)
        end
      end

      class Mock
        # TODO provide implementation
        def list_vminstances(_filters = {})
        end
      end
    end
  end
end
