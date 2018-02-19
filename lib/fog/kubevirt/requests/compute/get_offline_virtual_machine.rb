module Fog
  module Compute
    class Kubevirt
      class Real
        def get_offline_virtual_machine(name)
          to_hash client.get_offline_virtual_machines(:namespace => 'default', :name => 'name').first
        end
      end

      class Mock
        def get_offline_virtual_machine(name)
        end
      end
    end
  end
end

