module Fog
  module Kubevirt
    class Compute
      class Real
        def get_vm(name)
          Vm.parse get_raw_vm(name)
        end

        def get_raw_vm(name)
          object_to_hash( kubevirt_client.get_virtual_machine(name, @namespace) )
        end
      end

      class Mock
        # TODO provide implementation
        def get_vm(name)
        end

        def get_raw_vm(name)
        end
      end
    end
  end
end
