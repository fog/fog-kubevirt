module Fog
  module Kubevirt
    class Compute
      class Real
        def delete_secret(name, namespace)
          kube_client.delete_secret(name, namespace)
        end
      end

      class Mock
        def delete_secret(_name, _namespace)
        end
      end
    end
  end
end
