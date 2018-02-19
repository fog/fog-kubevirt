require 'fog/core/collection'
require 'fog/kubevirt/models/compute/server'

module Fog
  module Compute
    class Kubevirt
      class Servers < Fog::Collection
        model Fog::Compute::Kubevirt::Server

        def all(filters = {})
          load service.list_offline_virtual_machines(filters)
        end

        def get(name)
          new service.get_offline_virtual_machine(name)
        end
      end
    end
  end
end
