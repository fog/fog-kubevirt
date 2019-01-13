require 'recursive_open_struct'

module Fog
  module Kubevirt
    class Compute
      class Real
        def get_networkattachmentdef(name)
          net_attach_def = kube_net_client.get_network_attachment_definition(name, @namespace)
          Networkattachmentdef.parse object_to_hash(net_attach_def)
        end
      end

      class Mock
        def get_networkattachmentdef(name)
        end
      end
    end
  end
end
