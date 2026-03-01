require 'fog/core/collection'
require 'fog/kubevirt/compute/models/secret'

module Fog
  module Kubevirt
    class Compute
      class Secrets < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Secret

        def all(filters = {})
          begin
            secrets = service.list_secrets(filters)

            @kind = secrets.kind
            @resource_version = secrets.resource_version
          rescue ::Fog::Kubevirt::Errors::ClientError
            secrets = []
            @kind = 'Secret'
          end

          load secrets
        end

        def get(name)
          new service.get_secret(name)
        end

        def delete(name)
          begin
            secret = get(name)
          rescue ::Fog::Kubevirt::Errors::ClientError
            secret = nil
          end

          service.delete_secret(name, service.namespace) unless secret.nil?
        end
      end
    end
  end
end
