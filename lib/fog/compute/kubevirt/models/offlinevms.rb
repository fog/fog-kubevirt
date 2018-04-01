require 'fog/core/collection'
require 'fog/compute/kubevirt/models/offlinevm'

module Fog
  module Compute
    class Kubevirt
      class Offlinevms < Fog::Collection
        model Fog::Compute::Kubevirt::Offlinevm

        def all(filters = {})
          load service.list_offlinevms(filters)
        end

        def get(name)
          new service.get_offlinevm(name)
        end
      end
    end
  end
end
