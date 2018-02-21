module Fog
  module Compute
    class Kubevirt
      class Real
        def get_offline_virtual_machine(name)
          Offlinevm.parse object_to_hash( client.get_offline_virtual_machine(name, 'default') )
        end
      end

      class Mock
        def get_offline_virtual_machine(name)
        end
      end
    end
  end
end

