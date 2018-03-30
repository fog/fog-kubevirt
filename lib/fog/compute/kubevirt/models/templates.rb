require 'fog/core/collection'
require 'fog/kubevirt/models/compute/template'

module Fog
  module Compute
    class Kubevirt
      class Templates < Fog::Collection
        model Fog::Compute::Kubevirt::Template

        def all(filters = {})
          load service.list_templates(filters)
        end

        def get(name)
          new service.get_template(name)
        end
      end
    end
  end
end
