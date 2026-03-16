module Fog
  module Kubevirt
    class Compute
      class Real
        def get_secret(name, namespace = @namespace)
          Secret.parse object_to_hash(kube_client.get_secret(name, namespace))
        end
      end

      class Mock
        def get_secret(_name, _namespace = @namespace)
          {}
        end
      end
    end
  end
end
