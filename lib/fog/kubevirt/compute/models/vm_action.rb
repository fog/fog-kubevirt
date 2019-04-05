module Fog
  module Kubevirt
    class Compute
      module VmAction
        def start(options = {})
          # Change the `running` attribute to `true` so that the virtual machine controller will take it and
          # create the virtual machine instance.
          vm = service.get_raw_vm(name)
          vm = deep_merge!(vm,
            :spec => {
              :running => true
            }
          )
          service.update_vm(vm)
        end

        def stop(options = {})
          vm = service.get_raw_vm(name)
          vm = deep_merge!(vm,
            :spec => {
              :running => false
            }
          )
          service.update_vm(vm)
        end
      end
    end
  end
end
