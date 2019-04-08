module Fog
  module Kubevirt
    class Compute
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
          [{:namespace=>"default", :name=>"ovs-foreman", :resource_version=>"1080", :uid=>"0e35b868-2464-11e9-93b4-525400c5a686", :config=>"{ \"cniVersion\": \"0.3.1\", \"type\": \"ovs\", \"bridge\": \"foreman\" }"}]
        end
      end
    end
  end
end
