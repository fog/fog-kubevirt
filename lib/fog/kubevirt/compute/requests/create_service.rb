module Fog
  module Kubevirt
    class Compute
      class Real
        def create_service(srv)
          kube_client.create_service(srv)
        end
      end

      class Mock
        def create_service(srv); end
      end
    end
  end
end