module Fog
  module Kubevirt
    class Compute
      module VmData

        #
        # Returns an array of parsed network interfaces
        #
        # @param object [Hash] A hash with raw interfaces data.
        #
        def parse_interfaces(object)
          return {} if object.nil?
          nics = []
          object.each do |iface|
            nic = VmNic.new
            nic.name = iface[:name]
            nic.mac_address = iface[:macAddress]
            nic.type = 'bridge' if iface.keys.include?(:bridge)
            nic.type = 'slirp' if iface.keys.include?(:slirp)
            nics << nic
          end

          nics
        end

        #
        # Returns an array of parsed networks
        #
        # @param object [Hash] A hash with raw networks data.
        #
        def parse_networks(object)
          return {} if object.nil?
          networks = []
          object.each do |net|
            network = VmNetwork.new
            network.name = net[:name]
            network.type = 'pod' if net.keys.include?(:pod)
            network.type = 'multus' if net.keys.include?(:multus)
            network.type = 'genie' if net.keys.include?(:genie)
            networks << network
          end

          networks
        end

        #
        # Returns an array of parsed disks
        #
        # @param object [Hash] A hash with raw disks data.
        #
        def parse_disks(object)
          return {} if object.nil?
          disks = []
          object.each do |d|
            disk = VmDisk.new
            disk.name = d[:name]
            disk.boot_order = d[:bootOrder]
            disk.volume_name = d[:volumeName]

            if d.keys.include?(:cdrom)
              disk.type = 'cdrom'
              disk.bus = d.dig(:cdrom, :bus)
              disk.readonly = d.dig(:cdrom, :readonly)
            elsif d.keys.include?(:disk)
              disk.type = 'disk'
              disk.bus = d.dig(:disk, :bus)
              disk.readonly = d.dig(:disk, :readonly)
            elsif d.keys.include?(:floppy)
              disk.type = 'floppy'
              disk.readonly = d.dig(:floppy, :readonly)
            elsif d.keys.include?(:lun)
              disk.type = 'lun'
              disk.readonly = d.dig(:lun, :readonly)
            end
            disks << disk
          end

          disks
        end

        #
        # Returns an array of parsed volumes
        #
        # @param object [Hash] A hash with raw volumes data.
        #
        def parse_volumes(object)
          return {} if object.nil?
          volumes = []
          object.each do |v|
            volume = VmVolume.new
            volume.name = v[:name]
            if v.keys.include?(:containerDisk)
              volume.type = 'containerDisk'
              volume.info = v.dig(:containerDisk, :image)
            elsif v.keys.include?(:persistentVolumeClaim)
              volume.type = 'persistentVolumeClaim'
              volume.info = v.dig(:persistentVolumeClaim, :claimName)
            elsif v.keys.include?(:emptyDisk)
              volume.type = 'emptyDisk'
              volume.info = v.dig(:emptyDisk, :capacity)
            elsif v.keys.include?(:ephemeral)
              volume.type = 'ephemeral'
              volume.info = v.dig(:ephemeral, :persistentVolumeClaim, :claimName)
            elsif v.keys.include?(:cloudInitNoCloud)
              volume.type = 'cloudInitNoCloud'
              volume.info = v.dig(:cloudInitNoCloud, :userDataBase64)
            elsif v.keys.include?(:hostDisk)
              volume.type = 'hostDisk'
              volume.info = v.dig(:hostDisk, :path)
            elsif v.keys.include?(:secret)
              volume.type = 'secret'
              volume.info = v.dig(:secret, :secretName)
            elsif v.keys.include?(:dataVolume)
              volume.type = 'dataVolume'
              volume.info = v.dig(:dataVolume, :name)
            elsif v.keys.include?(:serviceAccount)
              volume.type = 'serviceAccount'
              volume.info = v.dig(:serviceAccount, :serviceAccountName)
            elsif v.keys.include?(:configMap)
              volume.type = 'configMap'
              volume.info = v.dig(:configMap, :name)
            end
            volumes << volume
          end

          volumes
        end

        class VmNic
          attr_accessor :name,
                        :mac_address,
                        :type, # values: bridge, slirp
                        :model,
                        :ports,
                        :boot_order
          alias :mac :mac_address
        end

        class VmNetwork
          attr_accessor :name,
                        :type # values: multus, pod, genie
        end

        class VmDisk
          attr_accessor :name,
                        :volume_name,
                        :boot_order,
                        :type, # values: cdrom, disk, floppy, lun
                        :bus,
                        :readonly
        end

        class VmVolume < Fog::Model
          identity :name
          attribute :id
          # values: containerDisk, persistentVolumeClaim, emptyDisk,
          #         ephemeral, cloudInitNoCloud, hostDisk, secret,
          #         dataVolume, serviceAccount, configMap
          attribute :type

          attribute :info # specific piece of information per volume type

          def persisted?
            !name.nil?
          end
        end
      end
    end
  end
end
