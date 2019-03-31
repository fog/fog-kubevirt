require 'fog/kubevirt/compute/models/pvc'

module Fog
  module Kubevirt
    class Compute
      # Volumes represents volumes exist on kubevirt for vms:
      # If volume is attached to a VM by disk, it will contain the attachment properties
      # Disk Attachment properties are: boot_order and bus (when avaiable).
      # If the volume isn't attached to any VM, it will contain name, type and info.
      # When the volume type is persistentVolumeClaim, it will contain also the claim entity
      # In order to create a new volume, user have to create a Claim when wishes to use PVC
      # by using the pvcs collection.
      class Volume < Fog::Model
          identity :name

          # values: containerDisk, persistentVolumeClaim, emptyDisk,
          #         ephemeral, cloudInitNoCloud, hostDisk, secret,
          #         dataVolume, serviceAccount, configMap
          attribute :type

          # specific piece of information per volume type
          # for containerDisk - contains the image
          # for persistentVolumeClaim - contains the claim name
          attribute :info

          # holds the pvc entity if its type is persistentVolumeClaim
          attribute :pvc

          # Hash that holds volume type specific configurations, used for adding volume for a vm
          attribute :config

          # Disk attachment properties:

          # the order (integer) of the device during boot sequence
          attribute :boot_order

          # detemines how the disk will be presented to the guest OS if available
          attribute :bus

          def persisted?
            !name.nil?
          end

        def self.parse(object, disk)
          byebug
          volume = parse_object(object)
          volume[:boot_order] = object[:bootOrder]
          volume
        end
      end
    end
  end
end
