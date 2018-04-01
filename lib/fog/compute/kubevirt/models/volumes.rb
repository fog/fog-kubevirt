require 'fog/core/collection'
require 'fog/compute/kubevirt/models/volume'

module Fog
  module Compute
    class Kubevirt
      class Volumes < Fog::Collection
        model Fog::Compute::Kubevirt::Volume
      end
    end
  end
end
