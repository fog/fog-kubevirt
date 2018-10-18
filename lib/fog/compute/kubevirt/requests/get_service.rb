module Fog
  module Compute
    class Kubevirt
      class Real
        def get_service(name)
          Service.parse object_to_hash(kube_client.get_service(name, @namespace))
        end
      end

      class Mock
        def get_service(name)
        end
      end
    end
  end
end