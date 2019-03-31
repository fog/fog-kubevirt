require 'fog/core/collection'
require 'fog/compute/kubevirt/models/volume'

module Fog
  module Compute
    class Kubevirt
      class Volumes < Fog::Collection
        model Fog::Compute::Kubevirt::Volume

        attr_accessor :vm

        def all(vm_name = nil)
          service.list_volumes(vm_name)
        end
      end
    end
  end
end
