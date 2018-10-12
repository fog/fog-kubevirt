module Fog
  module Kubevirt
    class Compute
      class Real
        def delete_service(name, namespace)
          kube_client.delete_service(name, namespace)
        end
      end

      class Mock
        def delete_service(name)
        end
      end
    end
  end
end