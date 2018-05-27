require 'fog/core/collection'
require 'fog/compute/kubevirt/models/node'

module Fog
  module Compute
    class Kubevirt
      class Nodes < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Compute::Kubevirt::Node

        def all(filters = {})
          nodes = service.list_nodes(filters)
          kind = nodes.kind
          resource_version = nodes.resource_version
          load nodes
        end

        def get(name)
          new service.get_node(name)
        end
      end
    end
  end
end
