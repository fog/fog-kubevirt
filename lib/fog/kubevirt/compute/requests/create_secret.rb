module Fog
  module Kubevirt
    class Compute
      class Real
        def create_secret(secret)
          result = kube_client.create_secret(secret)
          Secret.parse object_to_hash(result)
        end
      end

      class Mock
        def create_secret(_secret)
          {}
        end
      end
    end
  end
end
