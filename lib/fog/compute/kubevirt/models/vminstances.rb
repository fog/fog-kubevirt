require 'fog/core/collection'
require 'fog/compute/kubevirt/models/vminstance'

module Fog
  module Compute
    class Kubevirt
      class Vminstances < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Compute::Kubevirt::Vminstance

        def all(filters = {})
          begin
            vms = service.list_vminstances(filters)
          rescue ::Fog::Kubevirt::Errors::ClientError
            # we assume that we get 404
            vms = []
          end
          @kind = vms.kind
          @resource_version = vms.resource_version
          load vms
        end

        def get(name)
          new service.get_vminstance(name)
        end

        def destroy(name, namespace)
          begin
            vm_instance = get(name)
          rescue ::Fog::Kubevirt::Errors::ClientError
            # the virtual machine instance doesn't exist
            vm_instance = nil
          end

          # delete vm
          service.delete_vm(name, namespace)

          # delete vm instance
          service.delete_vminstance(name, namespace) unless vm_instance.nil?
        end
      end
    end
  end
end
