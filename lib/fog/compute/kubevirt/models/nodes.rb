require 'fog/core/collection'
require 'fog/compute/kubevirt/models/node'

module Fog
  module Compute
    class Kubevirt
      class Nodes < Fog::Collection
        model Fog::Compute::Kubevirt::Node

        def all(filters = {})
          load service.list_nodes(filters)
        end

        def get(name)
          new service.get_node(name)
        end
      end
    end
  end
end
