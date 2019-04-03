module Fog
  module Kubevirt
    class Compute
      class Real
        def get_server(name)
          vm = get_raw_vm(name)
          populate_runtime_info(vm)
          Server.parse vm
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
        # TODO provide implementation
        def get_server(name)
          if name == "norma-huish.example.com"
            volume = Fog::Kubevirt::Compute::Volume.new
            volume.name = "norma-huish-example-com-disk-00"
            volume.type ="persistentVolumeClaim"
            volume.info="claimski1"
            volume.pvc=nil
            volume.config={:claimName=>"claimski1"}
            volume.boot_order=1
            volume.bus="virtio"

            vm_disk = Fog::Kubevirt::Compute::VmData::VmDisk.new
            vm_disk.name = "norma-huish-example-com-disk-00"
            vm_disk.boot_order = 1
            vm_disk.type = "disk"
            vm_disk.bus = "virtio"
            vm_disk.readonly = nil

            vm_nic = Fog::Kubevirt::Compute::VmData::VmNic.new
            vm_nic.mac_address = "a2:a4:b4:a8:a6:a6"
            vm_nic.type = "bridge"
            vm_nic.model = nil
            vm_nic.ports = nil
            vm_nic.boot_order = nil

            vm_network = Fog::Kubevirt::Compute::VmData::VmNetwork.new
            vm_network.name = "ovs-foreman"
            vm_network.type = "multus"

            return {
              :namespace => "default",
              :name=>"norma-huish.example.com",
              :resource_version=>"887626",
              :uid=>"f38cdc0a-55ee-11e9-9132-525400c5a686",
              :labels=>{:"kubevirt.io/vm"=>"norma-huish.example.com"},
              :disks=>[vm_disk],
              :volumes=> [volume],
              :status=>"stopped",
              :interfaces=>[vm_nic],
              :networks=>[],
              :machine_type=>"",
              :cpu_cores=>1,
              :memory=>"1024M",
              :state=>nil,
              :node_name=>nil,
              :ip_address=>nil
            }
          end

          if name == "blake-istre.example.com"
            volume = Fog::Kubevirt::Compute::Volume.new
            volume.name = "blake-istre-example-com-disk-00"
            volume.type ="containerDisk"
            volume.info="kubevirt/fedora-cloud-registry-disk-demo"
            volume.pvc=nil
            volume.config={:image=>"kubevirt/fedora-cloud-registry-disk-demo"}
            volume.boot_order=nil
            volume.bus="virtio"

            vm_disk = Fog::Kubevirt::Compute::VmData::VmDisk.new
            vm_disk.name = "blake-istre-example-com-disk-00"
            vm_disk.boot_order = nil
            vm_disk.type = "disk"
            vm_disk.bus = "virtio"
            vm_disk.readonly = nil

            vm_nic = Fog::Kubevirt::Compute::VmData::VmNic.new
            vm_nic.mac_address = "a2:a4:b6:a4:a2:a8"
            vm_nic.type = "bridge"
            vm_nic.model = nil
            vm_nic.ports = nil
            vm_nic.boot_order = nil

            vm_network = Fog::Kubevirt::Compute::VmData::VmNetwork.new
            vm_network.name = "ovs-foreman"
            vm_network.type = "multus"

            {
              :namespace => "default",
              :name=>"blake-istre.example.com",
              :resource_version=>"963318",
              :uid=>"926c9aa4-569d-11e9-9132-525400c5a686",
              :labels=>{:"kubevirt.io/vm"=>"blake-istre.example.com"},
              :disks=>[vm_disk],
              :volumes=> [volume],
              :status=>"stopped",
              :interfaces=>[vm_nic],
              :networks=>[vm_network],
              :machine_type=>"",
              :cpu_cores=>1,
              :memory=>"1024M",
              :state=>nil,
              :node_name=>nil,
              :ip_address=>nil
            }
          end
        end
      end
    end
  end
end
