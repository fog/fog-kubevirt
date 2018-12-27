module Fog
  module Compute
    class Kubevirt
      class Real
        def list_networkattachmentdefs(_filters = {})
          netdefs = kube_net_client.get_network_attachment_definitions
          entities = netdefs.map do |kubevirt_obj|
            Networkattachmentdef.parse object_to_hash(kubevirt_obj)
          end
          EntityCollection.new(netdefs.kind, netdefs.resourceVersion, entities)
        end
      end

      class Mock
        # TODO provide implementation
        def list_networkattachmentdefs(_filters = {})
        end
      end
    end
  end
end
