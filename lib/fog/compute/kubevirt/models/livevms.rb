require 'fog/core/collection'
require 'fog/compute/kubevirt/models/livevm'

module Fog
  module Compute
    class Kubevirt
      class Livevms < Fog::Collection
        attr_reader :kind, :resourceVersion

        model Fog::Compute::Kubevirt::Livevm

        def all(filters = {})
          vms = service.list_livevms(filters)
          kind = vms.kind
          resourceVersion = vms.resourceVersion
          load vms
        end

        def get(name)
          new service.get_livevm(name)
        end

        def destroy(name, namespace)
          begin
            live_vm = get(name)
          rescue KubeException
            # the live virtual machine doesn't exist
            live_vm = nil
          end

          # delete offline vm
          service.delete_offlinevm(name, namespace)

          # delete live vm
          service.delete_livevm(name, namespace) unless live_vm.nil?
        end
      end
    end
  end
end