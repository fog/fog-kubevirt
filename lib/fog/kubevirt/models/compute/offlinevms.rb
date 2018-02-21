require 'fog/core/collection'
require 'fog/kubevirt/models/compute/offlinevm'

module Fog
  module Compute
    class Kubevirt
      class Offlinevms < Fog::Collection
        model Fog::Compute::Kubevirt::Offlinevm

        def all(filters = {})
          load service.list_offlinevms(filters)
        end

        def get(name)
          new service.get_offline_virtual_machine(name)
        end
      end
    end
  end
end
