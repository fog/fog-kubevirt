require 'fog/compute/kubevirt/models/pvc'

module Fog
  module Compute
    class Kubevirt
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
          # The set of config properties may change from type to type, see documentation for the supported
          # keys of each volume type:
          # https://kubevirt.io/user-guide/docs/latest/creating-virtual-machines/disks-and-volumes.html#volumes
          attribute :config

          # Disk attachment properties, relevant when volumes are fetched via the vm:

          # the order (integer) of the device during boot sequence
          attribute :boot_order

          # detemines how the disk will be presented to the guest OS if available, supported values are:
          # virtio, sata or scsi. See https://kubevirt.io/api-reference/master/definitions.html#_v1_disktarget
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
