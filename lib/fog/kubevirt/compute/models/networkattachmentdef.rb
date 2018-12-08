module Fog
  module Kubevirt
    class Compute
      class Networkattachmentdef < Fog::Model
        identity :name

        attribute :namespace,        :aliases => 'metadata_namespace'
        attribute :resource_version, :aliases => 'metadata_resource_version'
        attribute :uid,              :aliases => 'metadata_uid'
        attribute :config,           :aliases => 'spec_config'

        def self.parse(object)
          metadata = object[:metadata]
          {
            :namespace        => metadata[:namespace],
            :name             => metadata[:name],
            :resource_version => metadata[:resourceVersion],
            :uid              => metadata[:uid],
            :config           => object[:spec][:config]
          }
        end
      end
    end
  end
end
