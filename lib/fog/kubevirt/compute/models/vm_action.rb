module Fog
  module Kubevirt
    class Compute
      module VmAction
        # Handles both legacy (spec.running) and modern (spec.runStrategy) formats

        def start(options = {})
          vm = service.get_raw_vm(name)

          spec = vm.dig(:spec, :running).nil? ? { runStrategy: "Always" } : { running: true }
          vm = deep_merge!(vm, :spec => spec)

          service.update_vm(vm)
        end

        def stop(options = {})
          vm = service.get_raw_vm(name)

          spec = vm.dig(:spec, :running).nil? ? { runStrategy: "Halted" } : { running: false }
          vm = deep_merge!(vm, :spec => spec)

          service.update_vm(vm)
        end
      end
    end
  end
end
