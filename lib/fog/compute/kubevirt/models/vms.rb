require 'fog/core/collection'
require 'fog/compute/kubevirt/models/vm'

module Fog
  module Compute
    class Kubevirt
      class Vms < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Compute::Kubevirt::Vm

        def all(filters = {})
          vms = service.list_vms(filters)
          @kind = vms.kind
          @resource_version = vms.resource_version
          load vms
        end

        def get(name)
          new service.get_vm(name)
        end
      end
    end
  end
end
