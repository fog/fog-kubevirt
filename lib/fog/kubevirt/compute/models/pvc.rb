module Fog
  module Kubevirt
    class Compute
      class Pvc < Fog::Model
        # Metadata
        identity :name
        attribute :resource_version,  :aliases => 'metadata_resource_version'
        attribute :uid,               :aliases => 'metadata_uid'
        attribute :namespace,         :aliases => 'metadata_namespace'

        # Spec
        attribute :access_modes,      :aliases => 'spec_access_modes'
        attribute :storage_class,     :aliases => 'spec_storage_class'
        attribute :volume_mode,       :aliases => 'spec_volume_mode'
        attribute :volume_name,       :aliases => 'spec_volume_name'

        # Spec - selector
        attribute :match_expressions, :aliases => 'spec_match_expressions'
        attribute :match_labels,      :aliases => 'spec_match_labels'

        # Spec - resources
        attribute :limits,            :aliases => 'spec_limits'
        attribute :requests,          :aliases => 'spec_requests'

        # Status
        attribute :phase,             :aliases => 'status_phase'
        attribute :reason,            :aliases => 'status_reason'
        attribute :message,           :aliases => 'status_message'

        def self.parse(object)
          metadata = object[:metadata]
          spec = object[:spec]
          status = object[:status]

          {
            :name              => metadata[:name],
            :resource_version  => metadata[:resourceVersion],
            :uid               => metadata[:uid],
            :namespace         => metadata[:namespace],

            :access_modes      => spec[:accessModes],
            :storage_class     => spec[:storageClassName],
            :volume_mode       => spec[:volumeMode],
            :volume_name       => spec[:volumeName],

            :match_expressions => spec.dig(:selector, :matchExpressions),
            :match_labels      => spec.dig(:selector, :matchLabels),
            :limits            => spec.dig(:resources, :limits),
            :requests          => spec.dig(:resources, :requests),

            :phase             => status[:phase],
            :reason            => status[:reason],
            :message           => status[:message]
          }
        end
      end
    end
  end
end
