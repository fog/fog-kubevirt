module Fog
  module Compute
    class Kubevirt
      class Real
        def delete_livevm(name, namespace = nil)
          kubevirt_client.delete_virtual_machine(name, namespace)
        end
      end

      class Mock
        def delete_livevm(name, namespace = nil)
        end
      end
    end
  end
end
