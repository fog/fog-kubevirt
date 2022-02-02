require 'fog/core/collection'
require 'fog/kubevirt/compute/models/template'

module Fog
  module Kubevirt
    class Compute
      class Templates < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Template

        def all(filters = {})
          begin
            temps = service.list_templates(filters)

            @kind = temps.kind
            @resource_version = temps.resource_version
          rescue ::Fog::Kubevirt::Errors::ClientError
            # we assume that we get 404
            temps = []

            @kind = 'Template'
          end

          load temps
        end

        def get(name)
          new service.get_template(name)
        end
      end
    end
  end
end
