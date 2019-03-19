module Fog
  module Kubevirt
    class Compute
      class Storageclass < Fog::Model
        # Metadata
        identity :name
        attribute :resource_version,  :aliases => 'metadata_resource_version'
        attribute :uid,               :aliases => 'metadata_uid'

        attribute :mount_options
        attribute :parameters
        attribute :provisioner
        attribute :reclaim_policy
        attribute :volume_binding_mode

        def self.parse(object)
          metadata = object[:metadata]
          {
            :name                => metadata[:name],
            :resource_version    => metadata[:resourceVersion],
            :uid                 => metadata[:uid],

            :parameters          => object[:parameters],
            :mount_options       => object[:mountOptions],
            :provisioner         => object[:provisioner],
            :reclaim_policy      => object[:reclaimPolicy],
            :volume_binding_mode => object[:volumeBindingMode]
          }
        end
      end
    end
  end
end
