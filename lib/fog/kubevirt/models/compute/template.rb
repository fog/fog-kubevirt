module Fog
  module Compute
    class Kubevirt
      class Template < Fog::Model
        identity :name, :aliases => 'metadata_name'

        attr_accessor :raw

        attribute :memory,      :aliases => 'metadata_memory'
        attribute :api_version, :aliases => 'apiVersion'
        attribute :namespace,   :aliases => 'metadata_namespace'
        attribute :metadata
        attribute :spec

        def to_s
          name
        end
      end
    end
  end
end
