require 'fog/core/collection'
require 'fog/kubevirt/compute/models/vm'

module Fog
  module Kubevirt
    class Compute
      class Vms < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Vm

        def all(filters = {})
          begin
            vms = service.list_vms(filters)
          rescue ::Fog::Kubevirt::Errors::ClientError
            # we assume that we get 404
            vms = []
          end
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
