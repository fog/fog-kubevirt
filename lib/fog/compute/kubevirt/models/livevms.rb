require 'fog/core/collection'
require 'fog/compute/kubevirt/models/livevm'

module Fog
  module Compute
    class Kubevirt
      class Livevms < Fog::Collection
        model Fog::Compute::Kubevirt::Livevm

        def all(filters = {})
          load service.list_livevms(filters)
        end

        def get(name)
          new service.get_livevm(name)
        end

        def destroy(name)
          begin
            live_vm = get(name)
          rescue KubeException
            # the live virtual machine doesn't exist
            live_vm = nil
          end

          # delete live vm
          service.destroy_vm(name) unless live_vm.nil?

          # delete offline vm
          service.delete_offlinevm(name)
        end
      end
    end
  end
end