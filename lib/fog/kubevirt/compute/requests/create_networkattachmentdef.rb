module Fog
  module Kubevirt
    class Compute
      class Real
        include Shared

        # creates netwrork attachment definition object
        # @param net_att[Hash] contains the following elements:
        # metadata[Hash]: the net-attachment-def metadata:
        #   name[String]: the netwrork attachment definition definition
        #   spec[Hash]: the specification of the attachment, contains:config
        #     config[string]: the configuration of the attachment, i.e.
        #      '{ :cniVersion => "0.3.1", :type => "ovs", :bridge => "red" }'
        # Example of net_att:
        # metadata: {
        #             name: "ovs-red"},
        #             spec: {
        #               config: '{ cni_version: "0.3.1", type: "ovs", bridge: "red" }'
        #           }
        def create_networkattachmentdef(net_att)
          if net_att.dig(:metadata, :namespace).nil?
            net_att = deep_merge!(net_att, metadata: { namespace: @namespace })
          end
          kube_net_client.create_network_attachment_definition(net_att)
        end
      end

      class Mock
        def create_networkattachmentdef(_net_att_def)
        end
      end
    end
  end
end
