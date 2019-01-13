require 'fog/core/collection'
require 'fog/kubevirt/compute/models/networkattachmentdef'

module Fog
  module Kubevirt
    class Compute
      class Networkattachmentdefs < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Networkattachmentdef

        def all(filters = {})
          networkattachmentdefs = service.list_networkattachmentdefs(filters)
          @kind = networkattachmentdefs.kind
          @resource_version = networkattachmentdefs.resource_version
          load networkattachmentdefs
        end

        def get(name)
          new service.get_networkattachmentdef(name)
        end

        # Creates network attachment definition using provided parameters:
        # name[String] - name of the network attachment
        # config[String] - the configuration of the attachment, i.e.:
        #   '{ :cniVersion => "0.3.1", :type => "ovs", :bridge => "red" }'
        #
        # @param args[Hash] contains attachment definition
        def create(args = {})
          name = args[:name]
          config = args[:config]

          net_att_def = {
            :metadata => {
              :name      => name,
              :namespace => service.namespace
            },
            :spec => {
              :config => config
            }
          }

          service.create_networkattachmentdef(net_att_def)
        end

        def delete(name)
          begin
            net_att_def = get(name)
          rescue ::Fog::Kubevirt::Errors::ClientError
            # the network attachment definition doesn't exist
            net_att_def = nil
          end

          service.delete_networkattachmentdef(name, service.namespace) unless net_att_def.nil?
        end
      end
    end
  end
end
