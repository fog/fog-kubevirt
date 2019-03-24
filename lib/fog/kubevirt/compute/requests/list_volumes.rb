require 'recursive_open_struct'

module Fog
  module Kubevirt
    class Compute
      class Real
        def list_volumes(vm_name = nil)
          if vm_name.nil?
            entities = pvcs.all.map do |pvc|
              volume = Volume.new
              volume.name = pvc.name
              volume.type = 'persistentVolumeClaim'
              volume.pvc = pvc
              volume
            end
            EntityCollection.new('Volume', pvcs.resource_version, entities)
          else
            vm = vms.get(vm_name)
            EntityCollection.new('Volume', vm.resource_version, vm.volumes)
          end
        end
      end

      class Mock
        def list_volumes(vm_name = nil)
        end
      end
    end
  end
end
