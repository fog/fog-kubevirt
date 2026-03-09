require 'recursive_open_struct'

module Fog
  module Kubevirt
    class Compute
      class Real
        def list_secrets(filters = {})
          filters = {
            namespace: @namespace
          }.merge(filters)

          secrets = kube_client.get_secrets(filters)
          entities = secrets.map do |kubevirt_obj|
            Secret.parse object_to_hash(kubevirt_obj)
          end
          EntityCollection.new(secrets.kind, secrets.resourceVersion, entities)
        end
      end

      class Mock
        def list_secrets(_filters = {})
        end
      end
    end
  end
end
