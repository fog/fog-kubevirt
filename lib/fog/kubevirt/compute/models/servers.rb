require 'fog/core/collection'
require 'fog/kubevirt/compute/models/server'

module Fog
  module Kubevirt
    class Compute
      class Servers < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Server

        def all(filters = {})
          servers = service.list_servers(filters)
          @kind = servers.kind
          @resource_version = servers.resource_version
          load servers
        end

        def get(id)
          new service.get_server(id)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { stopped? }
          server.start
          server
        end
      end
    end
  end
end
