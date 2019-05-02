module Fog
  module Kubevirt
    class Compute
      class Real

        def create_vminstance(vm)
          kubevirt_client.create_virtual_machine_instance(vm)
        end
      end

      class Mock
        def create_vminstance(vm)
        end
      end
    end
  end
end
