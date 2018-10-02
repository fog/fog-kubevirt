require 'fog/core/collection'
require 'fog/kubevirt/compute/models/node'

module Fog
  module Kubevirt
    class Compute
      class Nodes < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Node

        def all(filters = {})
          nodes = service.list_nodes(filters)
          @kind = nodes.kind
          @resource_version = nodes.resource_version
          load nodes
        end

        def get(name)
          new service.get_node(name)
        end
      end
    end
  end
end
