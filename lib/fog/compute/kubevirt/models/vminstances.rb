require 'fog/core/collection'
require 'fog/compute/kubevirt/models/vminstance'

module Fog
  module Compute
    class Kubevirt
      class Vminstances < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Compute::Kubevirt::Vminstance

        def all(filters = {})
          vms = service.list_vminstances(filters)
          kind = vms.kind
          resource_version = vms.resource_version
          load vms
        end

        def get(name)
          new service.get_vminstance(name)
        end

        def destroy(name, namespace)
          begin
            vm_instance = get(name)
          rescue Kubeclient::HttpError
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
