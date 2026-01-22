module Fog
  module Kubevirt
    class Compute
      class Real
        def get_vm(name)
          vm = Vm.parse get_raw_vm(name)
          populate_pvcs_for_vm(vm)
          vm
        end

        def populate_pvcs_for_vm(vm)
          vm[:volumes].each do |vol|
            set_volume_pvc_attributes(vol)
          end
        end

        def set_volume_pvc_attributes(volume, pvc = nil)
          return unless volume.type == 'persistentVolumeClaim'
          if pvc.nil?
            begin
              pvc = pvcs.get(volume.info)
            rescue
              # there is an option that the PVC does not exist
              return
            end
          end

          volume.pvc = pvc
          volume.capacity = pvc&.requests[:storage]
          volume.storage_class = pvc.storage_class
        end

        def get_raw_vm(name)
          object_to_hash(kubevirt_client.get_virtual_machine(name, @namespace))
        end
      end

      class Mock
        def get_vm(name)
          Vm.parse get_raw_vm(name)
        end

        def get_raw_vm(name)
          {
            :apiVersion=>"kubevirt.io/v1alpha3",
            :kind=>"VirtualMachine",
            :metadata=>{
              :creationTimestamp=>"2019-04-02T13:28:47Z",
              :generation=>1,
              :labels=>{
                :special=>"vm-multus-multiple-net"
              },
              :name=>"vm-multus-multiple-net",
              :namespace=>"default",
              :resourceVersion=>"24453",
              :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/vm-multus-multiple-net",
              :uid=>"3e959de9-554b-11e9-a3d6-525500d15501"
            },
            :spec=>{
              :running=>false,
              :template=>{
                :metadata=>{
                  :labels=>{
                    :"kubevirt.io/vm"=>"vm-multus-multiple-net"
                  }
                },
                :spec=>{
                  :domain=>{
                    :devices=>{
                      :disks=>[
                        {
                          :disk=>{:bus=>"virtio"},
                          :name=>"containerdisk"
                        },
                        {
                          :disk=>{:bus=>"virtio"},
                          :name=>"cloudinitdisk"
                        }
                      ],
                      :interfaces=>[
                        {
                          :bridge=>{},
                          :name=>"default"
                        },
                        {
                          :bridge=>{},
                          :name=>"ptp"
                        }
                      ]
                    },
                    :machine=>{
                      :type=>""
                    },
                    :resources=>{
                      :requests=>{
                        :memory=>"1024M"
                      }
                    }
                  },
                  :networks=>[
                    {
                      :name=>"default",
                      :pod=>{}
                    },
                    {
                      :multus=>{
                        :networkName=>"ptp-conf"
                      },
                      :name=>"ptp"
                    }
                  ],
                  :terminationGracePeriodSeconds=>0,
                  :volumes=>[
                    {
                      :containerDisk=>{:image=>"registry:5000/kubevirt/fedora-cloud-container-disk-demo:devel"},
                      :name=>"containerdisk"
                    },
                    {
                      :cloudInitNoCloud=>{:userData=>"#!/bin/bash\necho \"fedora\" |passwd fedora --stdin\ndhclient eth1\n"},
                      :name=>"cloudinitdisk"
                    }
                  ]
                }
              }
            },
            :status=>{
              :printableStatus=>"Running",
            }
          }
        end
      end
    end
  end
end
