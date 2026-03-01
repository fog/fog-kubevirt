module Fog
  module Kubevirt
    class Compute
      class Real
        def update_secret(secret)
          result = kube_client.update_secret(secret)
          Secret.parse object_to_hash(result)
        end
      end

      class Mock
        def update_secret(_secret)
          {}
        end
      end
    end
  end
end
