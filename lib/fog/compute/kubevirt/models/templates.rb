require 'fog/core/collection'
require 'fog/compute/kubevirt/models/template'

module Fog
  module Compute
    class Kubevirt
      class Templates < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Compute::Kubevirt::Template

        def all(filters = {})
          temps = service.list_templates(filters)
          @kind = temps.kind
          @resource_version = temps.resource_version
          load temps
        end

        def get(name)
          new service.get_template(name)
        end
      end
    end
  end
end
