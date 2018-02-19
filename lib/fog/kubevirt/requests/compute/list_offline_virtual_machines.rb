module Fog
  module Compute
    class Kubevirt
      class Real
        def list_offline_virtual_machines(filters = {})
          client.get_offline_virtual_machines(:namespace => 'default').map {|kubevirt_obj| to_hash kubevirt_obj}
        end
      end

      class Mock
        def list_offline_virtual_machines(filters = {})
        end
      end
    end
  end
end

