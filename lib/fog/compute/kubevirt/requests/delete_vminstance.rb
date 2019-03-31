module Fog
  module Compute
    class Kubevirt
      class Real
        def delete_vminstance(name)
          kubevirt_client.delete_virtual_machine_instance(name, @namespace)
        end
      end

      class Mock
        def delete_virtual_machine_instance(name)
        end
      end
    end
  end
end
