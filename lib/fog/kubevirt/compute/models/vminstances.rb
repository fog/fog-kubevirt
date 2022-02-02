require 'fog/core/collection'
require 'fog/kubevirt/compute/models/vminstance'

module Fog
  module Kubevirt
    class Compute
      class Vminstances < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Vminstance

        def all(filters = {})
          begin
            vms = service.list_vminstances(filters)

            @kind = vms.kind
            @resource_version = vms.resource_version
          rescue ::Fog::Kubevirt::Errors::ClientError
            # we assume that we get 404
            vms = []

            @kind = 'VirtualMachineInstance'
          end

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
          service.delete_vminstance(name) unless vm_instance.nil?
        end

        def get_vnc_console_details(name, namespace)
          service.get_vnc_console_details(name, namespace)
        end
      end
    end
  end
end
