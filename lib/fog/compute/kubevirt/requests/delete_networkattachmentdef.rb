module Fog
  module Compute
    class Kubevirt
      class Real
        def delete_networkattachmentdef(name, namespace)
          kube_net_client.delete_network_attachment_definition(name, namespace)
        end
      end

      class Mock
        def delete_networkattachmentdef(_name, _namespace)
        end
      end
    end
  end
end
