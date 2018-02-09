require 'fog/core/collection'
require 'fog/kubevirt/models/compute/template'

module Fog
  module Compute
    class Kubevirt
      class Templates < Fog::Collection
        model Fog::Compute::Kubevirt::Template

      end
    end
  end
end
