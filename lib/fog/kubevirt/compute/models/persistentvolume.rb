module Fog
  module Kubevirt
    class Compute
      class Persistentvolume < Fog::Model
        identity :name

        attribute :resource_version, :aliases => 'metadata_resource_version'
        attribute :uid,              :aliases => 'metadata_uid'
        attribute :annotations,      :aliases => 'metadata_annotations'
        attribute :labels,           :aliases => 'metadata_labels'
		attribute :access_modes,	 :aliases => 'spec_access_modes'
		attribute :mount_options,	 :aliases => 'spec_mount_options'
		attribute :reclaim_policy,   :aliases => 'spec_reclaim_policy'
		attribute :storage_class,    :aliases => 'spec_storage_class'
        attribute :capacity,         :aliases => 'spec_capacity'
        attribute :claim_ref,        :aliases => 'spec_claim_ref'
        attribute :type,			 :aliases => 'spec_type'
        attribute :config,			 :aliases => 'spec_config'
        attribute :phase,            :aliases => 'status_phase'
        attribute :reason,            :aliases => 'status_reason'
        attribute :message,            :aliases => 'status_message'

        def self.parse(object)
          metadata = object[:metadata]
          spec = object[:spec]
          status = object[:status]
          type = detect_type(spec)

          {
            :name             => metadata[:name],
            :resource_version => metadata[:resourceVersion],
            :uid              => metadata[:uid],
            :annotations      => metadata[:annotations],
            :labels           => metadata[:labels],
            :access_modes     => spec[:accessModes],
            :mount_options    => spec[:mountOptions],
            :reclaim_policy   => spec[:persistentVolumeReclaimPolicy],
			:storage_class    => spec[:storageClassName],
            :capacity         => spec.dig(:capacity, :storage),
            :claim_ref        => spec[:claimRef],
            :type             => type,
            :config           => spec[type&.to_sym],
            :phase            => status[:phase],
            :reason           => status[:reason],
            :message          => status[:message]
          }
        end

        def self.detect_type(spec)
            type = ''
            type = 'awsElasticBlockStore' if spec.keys.include?(:awsElasticBlockStore)
            type = 'azureDisk' if spec.keys.include?(:azureDisk)
            type = 'azureFile' if spec.keys.include?(:azureFile)
            type = 'cephfs' if spec.keys.include?(:cephfs)
            type = 'configMap' if spec.keys.include?(:configMap)
            type = 'csi' if spec.keys.include?(:csi)
            type = 'downwardAPI' if spec.keys.include?(:downwardAPI)
            type = 'emptyDir' if spec.keys.include?(:emptyDir)
            type = 'fc' if spec.keys.include?(:fc)
            type = 'flexVolume' if spec.keys.include?(:flexVolume)
            type = 'flocker' if spec.keys.include?(:flocker)
            type = 'gcePersistentDisk' if spec.keys.include?(:gcePersistentDisk)
            type = 'glusterfs' if spec.keys.include?(:glusterfs)
            type = 'hostPath' if spec.keys.include?(:hostPath)
            type = 'iscsi' if spec.keys.include?(:iscsi)
            type = 'local' if spec.keys.include?(:local)
            type = 'nfs' if spec.keys.include?(:nfs)
            type = 'persistentVolumeClaim' if spec.keys.include?(:persistentVolumeClaim)
            type = 'projected' if spec.keys.include?(:projected)
            type = 'portworxVolume' if spec.keys.include?(:portworxVolume)
            type = 'quobyte' if spec.keys.include?(:quobyte)
            type = 'rbd' if spec.keys.include?(:rbd)
            type = 'scaleIO' if spec.keys.include?(:scaleIO)
            type = 'secret' if spec.keys.include?(:secret)
            type = 'storageos' if spec.keys.include?(:storageos)
            type = 'vsphereVolume' if spec.keys.include?(:vsphereVolume)
            type
        end
      end
    end
  end
end
