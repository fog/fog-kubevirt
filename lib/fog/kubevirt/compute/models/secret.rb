module Fog
  module Kubevirt
    class Compute
      class Secret < Fog::Model
        identity :name

        attribute :namespace,         :aliases => 'metadata_namespace'
        attribute :resource_version,  :aliases => 'metadata_resource_version'
        attribute :uid,               :aliases => 'metadata_uid'
        attribute :creation_timestamp, :aliases => 'metadata_creation_timestamp'
        # data: key => base64-encoded string value (caller must decode if needed)
        attribute :data
        attribute :type

        def self.parse(object)
          metadata = object[:metadata] || {}
          data_hash = object[:data].is_a?(Hash) ? object[:data] : {}

          {
            :name               => metadata[:name],
            :namespace          => metadata[:namespace],
            :resource_version   => metadata[:resourceVersion],
            :uid                => metadata[:uid],
            :creation_timestamp => metadata[:creationTimestamp],
            :data               => data_hash,
            :type               => object[:type]
          }
        end
      end
    end
  end
end
