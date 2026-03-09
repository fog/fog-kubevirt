module Fog
  module Kubevirt
    class Compute
      class Secret < Fog::Model
        identity :name

        attribute :namespace,          :aliases => 'metadata_namespace'
        attribute :resource_version,   :aliases => 'metadata_resource_version'
        attribute :uid,                :aliases => 'metadata_uid'
        attribute :creation_timestamp, :aliases => 'metadata_creation_timestamp'
        attribute :metadata
        # data: key => base64-encoded string value (caller must decode if needed)
        attribute :data
        attribute :type

        # Persisted if the secret has been stored in the API (uid is set by the server on create).
        def persisted?
          !uid.nil?
        end

        # Build hash for create/update API. data values must be base64-encoded.
        def to_secret_hash
          ns = namespace || service.namespace
          raise "Data must be a hash" unless (data || {}).is_a?(Hash)
          h = {
            :apiVersion => 'v1',
            :kind       => 'Secret',
            :metadata   => (metadata || {}).merge({
              :name      => name,
              :namespace => ns
            }),
            :data       => data,
            :type       => (type || 'Opaque')
          }
          h[:metadata][:resourceVersion] = resource_version if resource_version.to_s != ''
          h
        end

        def create
          created = service.create_secret(to_secret_hash)
          merge_attributes(created)
          self
        end

        def update
          updated = service.update_secret(to_secret_hash)
          merge_attributes(updated)
          self
        end

        def destroy
          service.delete_secret(name, namespace || service.namespace)
          self.uid = nil
          self
        end

        def self.parse(object)
          metadata = object[:metadata] || {}
          data_hash = object[:data] || {}
          raise "Data must be a hash" unless data_hash.is_a?(Hash)

          {
            :name               => metadata[:name],
            :namespace          => metadata[:namespace],
            :resource_version   => metadata[:resourceVersion],
            :uid                => metadata[:uid],
            :creation_timestamp => metadata[:creationTimestamp],
            :data               => data_hash,
            :type               => object[:type],
            :metadata           => metadata
          }
        end
      end
    end
  end
end
