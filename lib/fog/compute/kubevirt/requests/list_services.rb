require 'recursive_open_struct'

module Fog
  module Compute
    class Kubevirt
      class Real
        def list_services(_filters = {})
          services = kube_client.get_services(namespace: @namespace)
          entities = services.map do |kubevirt_obj|
            Service.parse object_to_hash(kubevirt_obj)
          end
          EntityCollection.new(services.kind, services.resourceVersion, entities)
        end
      end

      class Mock
        def list_services(_filters = {})
        end
      end
    end
  end
end
