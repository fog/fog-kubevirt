module Fog
  module Compute
    class Kubevirt
      class Real
        def list_livevms(_filters = {})
          kubevirt_client.get_virtual_machines(namespace: @namespace).map do |kubevirt_obj|
            Livevm.parse object_to_hash(kubevirt_obj)
          end
        end
      end

      class Mock
        def list_livevms(_filters = {})
        end
      end
    end
  end
end
