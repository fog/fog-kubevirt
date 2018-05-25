require 'fog/core/collection'
require 'fog/compute/kubevirt/models/offlinevm'

module Fog
  module Compute
    class Kubevirt
      class Offlinevms < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Compute::Kubevirt::Offlinevm

        def all(filters = {})
          ovms = service.list_offlinevms(filters)
          kind = ovms.kind
          resource_version = ovms.resource_version
          load ovms
        end

        def get(name)
          new service.get_offlinevm(name)
        end
      end
    end
  end
end
