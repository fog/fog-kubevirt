require 'fog/core/collection'
require 'fog/kubevirt/compute/models/volume'

module Fog
  module Kubevirt
    class Compute
      class Volumes < Fog::Collection
        model Fog::Kubevirt::Compute::Volume
      end
    end
  end
end
