require 'recursive_open_struct'
require 'fog/kubevirt/compute/requests/get_server'

module Fog
  module Kubevirt
    class Compute
      class Real
        def list_servers(_filters = {})
          vms = kubevirt_client.get_virtual_machines(namespace: @namespace)
          entities = vms.map do |kubevirt_obj|
            vm_obj = object_to_hash(kubevirt_obj)
            populate_runtime_info(vm_obj)
            Server.parse vm_obj
          end
          EntityCollection.new(vms.kind, vms.resourceVersion, entities)
        end
      end

      class Mock
        def list_servers(_filters = {})
        end
      end
    end
  end
end
