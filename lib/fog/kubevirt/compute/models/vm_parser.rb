require 'fog/kubevirt/compute/models/volume'
require 'fog/kubevirt/compute/models/vmnic'
require 'fog/kubevirt/compute/models/vm_data'

module Fog
  module Kubevirt
    class Compute
      module VmParser

        #
        # Returns an array of parsed network interfaces
        #
        # @param object [Hash] A hash with raw interfaces data.
        #
        def parse_interfaces(object, object_status, networks)
          return [] if object.nil?
          nics = []
          object.each do |iface|
            nic = VmNic.new
            nic.name = iface[:name]
            status_iface = object_status.find { |hash| hash[:name] == iface[:name] } unless object_status.nil?
            # get mac address from status and use device definition if not available
            nic.mac_address = !status_iface.nil? && status_iface.key?(:mac) ? status_iface[:mac] : iface[:macAddress]
            nic.type = 'bridge' if iface.keys.include?(:bridge)
            nic.type = 'slirp' if iface.keys.include?(:slirp)

            net = networks.detect { |n| n.name == iface[:name] }
            if net
              nic.cni_provider = net.type
              nic.network = net.network_name
            end

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
          return [] if object.nil?
          networks = []
          object.each do |net|
            network = VmData::VmNetwork.new
            network.name = net[:name]
            network.type = 'pod' if net.keys.include?(:pod)
            if net.keys.include?(:multus)
              network.type = 'multus'
              network.network_name = net[:multus][:networkName]
            end
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
          return [] if object.nil?
          disks = []
          object.each do |d|
            disk = VmData::VmDisk.new
            disk.name = d[:name]
            disk.boot_order = d[:bootOrder]

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
        # @param disks [Array] the disks of the vm associated to the volumes
        #
        def parse_volumes(object, disks)
          return [] if object.nil?
          volumes = []
          object.each do |v|
            volume = Volume.new
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

            volume.config = v[volume.type.to_sym]
            disk = disks.detect { |d| d.name == volume.name }
            volume.boot_order = disk.boot_order if disk.respond_to?(:boot_order)
            volume.bus = disk.bus if disk.respond_to?(:bus)

            volumes << volume
          end

          volumes
        end
      end
    end
  end
end
