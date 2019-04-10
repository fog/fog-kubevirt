module Fog
  module Kubevirt
    class Compute
      class Real
        def get_server(name)
          vm = get_raw_vm(name)
          populate_runtime_info(vm)
          server = Server.parse vm
          populate_pvcs_for_vm(server)
          server
        end

        # Updates a given VM raw entity with vm instance info if exists
        #
        # @param vm [Hash] A hash with vm raw data.
        def populate_runtime_info(vm)
          vmi = get_vminstance(vm[:metadata][:name])
          vm[:ip_address] = vmi[:ip_address]
          vm[:node_name] = vmi[:node_name]
          vm[:phase] = vmi[:status]
          vm
        rescue
          # do nothing if vmi doesn't exist
        end
      end

      class Mock
        def volume(name: "", type: "persistentVolumeClaim", info: "", pvc: nil, config: {}, boot_order: nil, bus: nil)
          volume = Fog::Kubevirt::Compute::Volume.new
          volume.name = name
          volume.type = type
          volume.info = info
          volume.pvc = pvc
          volume.config = config
          volume.boot_order = boot_order
          volume.bus = bus
          volume
        end

        def disk(name: "", boot_order: nil, type: "disk", bus: "virtio", readonly: nil)
          disk = Fog::Kubevirt::Compute::VmData::VmDisk.new
          disk.name = name
          disk.boot_order = boot_order
          disk.type = type
          disk.bus = bus
          disk.readonly = readonly
          disk
        end

        def vm_nic(mac_address: "")
          vm_nic = Fog::Kubevirt::Compute::VmNic.new
          vm_nic.mac_address = mac_address
          vm_nic.type = "bridge"
          vm_nic.model = nil
          vm_nic.ports = nil
          vm_nic.boot_order = nil
        end

        def get_server(name)
          if name == "robin-rykert.example.com"
            disk1 = disk(name: "robin-rykert-example-com-disk-00", boot_order: nil,type: "disk", bus: "virtio", readonly: nil)
            disk2 = disk(name: "robin-rykert-example-com-disk-01", boot_order: nil,type: "disk", bus: "virtio", readonly: nil)

            volume1 = volume(name: "robin-rykert-example-com-disk-00", type: "persistentVolumeClaim", info: "robin-rykert-example-com-claim-1",
                             pvc: nil, config: {:claimName=>"robin-rykert-example-com-claim-1"}, boot_order: nil, bus: "virtio")
            volume2 = volume(name: "robin-rykert-example-com-disk-01", type: "persistentVolumeClaim", info: "robin-rykert-example-com-claim-2",
                             pvc: nil, config: {:claimName=>"robin-rykert-example-com-claim-2"}, boot_order: nil, bus: "virtio")

            vm_network = Fog::Kubevirt::Compute::VmData::VmNetwork.new
            vm_network.name="ovs-foreman"
            vm_network.type="multus"

            return {
              :namespace=>"default",
              :name=>"robin-rykert.example.com",
              :resource_version=>"1020275",
              :uid=>"00ae63ee-5875-11e9-9132-525400c5a686",
              :labels=>{:"kubevirt.io/vm"=>"robin-rykert.example.com"},
              :disks=>[disk1, disk2],
              :volumes=>[volume1, volume2],
              :status=>"stopped",
              :interfaces=>[vm_nic(mac_address: "a2:b4:a2:b6:a2:a8")],
              :networks=>[vm_network],
              :machine_type=>"",
              :cpu_cores=>1,
              :memory=>"1024M",
              :state=>nil,
              :node_name=>nil,
              :ip_address=>nil
            }
          end

          if name == "olive-kempter.example.com"
            disk1 = disk(name: "olive-kempter-example-com-disk-00", boot_order: nil,type: "disk", bus: "virtio", readonly: nil)
            disk2 = disk(name: "olive-kempter-example-com-disk-01", boot_order: nil,type: "disk", bus: "virtio", readonly: nil)
            volume1 = volume(name: "olive-kempter-example-com-disk-00", type: "containerDisk", info: "kubevirt/fedora-cloud-registry-disk-demo",
                             pvc: nil, config: {:image=>"kubevirt/fedora-cloud-registry-disk-demo"}, boot_order: nil, bus: "virtio")
            volume2 = volume(name: "olive-kempter-example-com-disk-01", type: "containerDisk", info: "olive-kempter-example-com-claim-1",
                             pvc: nil, config: {:claimName=>"olive-kempter-example-com-claim-1"}, boot_order: nil, bus: "virtio")
            return {
              :namespace => "default",
              :name =>"olive-kempter.example.com",
              :resource_version => "1075555",
              :uid => "d4dba9e4-5945-11e9-9132-525400c5a686",
              :labels => {:"kubevirt.io/vm"=>"olive-kempter.example.com"},
              :disks => [disk1, disk2],
              :volumes => [ volume1, volume2],
              :status => "stopped",
              :interfaces => [vm_nic(mac_address: "a2:a4:a2:b2:a2:b6")],
              :networks => [vm_network],
              :machine_type => "",
              :cpu_cores => 1,
              :memory => "1024M",
              :state => nil,
              :node_name => nil,
              :ip_address => nil
            }
          end

          raise ::Fog::Kubevirt::Errors::ClientError, "HTTP status code 404, virtualmachines.kubevirt.io \"#{name}\" not found for GET"
        end
      end
    end
  end
end
