require 'recursive_open_struct'
require 'fog/kubevirt/compute/requests/get_server'

module Fog
  module Kubevirt
    class Compute
      class Real
        # filters[Hash]  - if contains ':pvcs' set to true will popoulate pvcs for vms
        def list_servers(filters = {})
          vms = kubevirt_client.get_virtual_machines(namespace: @namespace)
          entities = vms.map do |kubevirt_obj|
            vm_obj = object_to_hash(kubevirt_obj)
            populate_runtime_info(vm_obj)
            server = Server.parse vm_obj
            if filters[:pvcs]
              populate_pvcs_for_vm(server)
            end
            server
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
