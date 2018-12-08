require 'fog/core/collection'
require 'fog/compute/kubevirt/models/networkattachmentdefs'

module Fog
  module Compute
    class Kubevirt
      class Networkattachmentdefs < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Compute::Kubevirt::Networkattachmentdef

        def all(filters = {})
          networkattachmentdefs = service.list_networkattachmentdefs(filters)
          @kind = networkattachmentdefs.kind
          @resource_version = networkattachmentdefs.resource_version
          load networkattachmentdefs
        end

        def get(name)
          new service.get_networkattachmentdef(name)
        end
      end
    end
  end
end
