module Fog
  module Compute
    class Kubevirt
      class Real
        def delete_offlinevm(name, namespace)
          kubevirt_client.delete_offline_virtual_machine(name, namespace)
        end
      end

      class Mock
        def delete_offlinevm(name)
        end
      end
    end
  end
end