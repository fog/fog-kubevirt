module Fog
  module Compute
    class Kubevirt
      class Real
        def list_nodes(_filters = {})
          nodes = kube_client.get_nodes
          entities = nodes.map { |kubevirt_obj| Node.parse object_to_hash(kubevirt_obj) }
          EntityCollection.new(nodes.kind, nodes.resourceVersion, vms.metadata.uid, vms.metadata.type, entities)
        end
      end

      class Mock
        # TODO provide implementation
        def list_nodes(_filters = {})
        end
      end
    end
  end
end
