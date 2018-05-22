require 'fog/core/collection'
require 'fog/compute/kubevirt/models/node'

module Fog
  module Compute
    class Kubevirt
      class Nodes < Fog::Collection
        attr_reader :kind, :resourceVersion

        model Fog::Compute::Kubevirt::Node

        def all(filters = {})
          nodes = service.list_nodes(filters)
          kind = nodes.kind
          resourceVersion = nodes.resourceVersion
          load nodes
        end

        def get(name)
          new service.get_node(name)
        end
      end
    end
  end
end
