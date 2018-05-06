module Fog
  module Compute
    class Kubevirt
      class Real
        def list_nodes(_filters = {})
          kube_client.get_nodes.map { |kubevirt_obj| Node.parse object_to_hash(kubevirt_obj) }
        end
      end

      class Mock
        def list_nodes(_filters = {})
        end
      end
    end
  end
end
