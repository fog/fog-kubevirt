module Fog
  module Compute
    class Kubevirt
      class Real
        def delete_volume(name)
          kube_client.delete_persistent_volume(name)
        end
      end

      class Mock
        def delete_volume(name)
        end
      end
    end
  end
end