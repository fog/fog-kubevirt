require 'fog/compute/models/server'

module Fog
  module Compute
    class Kubevirt
      class Server < Fog::Compute::Server
        identity :name

        attribute :memory, :aliases => "resources_request_memory"
        attribute :metadata
        attribute :spec
        attribute :apiVersion, :aliases => "api_version"

        def start(options = {})

        end

        def stop(options = {})

        end

        def to_s
          name
        end
      end
    end
  end
end
