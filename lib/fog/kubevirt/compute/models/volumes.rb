require 'fog/core/collection'
require 'fog/kubevirt/compute/models/volume'

module Fog
  module Kubevirt
    class Compute
      class Volumes < Fog::Collection
        model Fog::Kubevirt::Compute::Volume

        attr_accessor :vm

        def all(vm_name = nil)
          service.list_volumes(vm_name)
        end
      end
    end
  end
end
