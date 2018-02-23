module Fog
  module Compute
    class Kubevirt
      class Real
        def get_offlinevm(name)
          Offlinevm.parse get_raw_offlinevm(name)
        end

        def get_raw_offlinevm(name)
          object_to_hash( kubevirt_client.get_offline_virtual_machine(name, 'default') )
        end
      end

      class Mock
        def get_offlinevm(name)
        end

        def get_raw_offlinevm(name)
        end
      end
    end
  end
end
