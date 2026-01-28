require 'recursive_open_struct'

module Fog
  module Kubevirt
    class Compute
      class Real
        def get_vminstance(name)
          # namespace is defined on the Real object
          Vminstance.parse object_to_hash( kubevirt_client.get_virtual_machine_instance(name, @namespace) )
        end
      end

      class Mock
        def get_vminstance(name)
          vm = {
            :apiVersion=>"kubevirt.io/v1alpha3",
            :kind=>"VirtualMachineInstance",
            :metadata=>{
              :creationTimestamp=>"2019-04-02T13:46:08Z",
              :finalizers=>["foregroundDeleteVirtualMachine"],
              :generation=>7,
              :labels=>{
                :"kubevirt.io/nodeName"=>"node02",
                :special=>"vmi-multus-multiple-net"
              },
              :name=>"vmi-multus-multiple-net",
              :namespace=>"default",
              :resourceVersion=>"27047",
              :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachineinstances/vmi-multus-multiple-net",
              :uid=>"ab5e450c-554d-11e9-a3d6-525500d15501"
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
                :features=>{
                  :acpi=>{:enabled=>true}
                },
                :firmware=>{:uuid=>"ff1ff019-c799-400f-9be1-375c3cee8b59"},
                :machine=>{:type=>"q35"},
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
                  :multus=>{:networkName=>"ptp-conf"},
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
            },
            :status=>{
              :conditions=>[
                {
                  :lastProbeTime=>nil,
                  :lastTransitionTime=>nil,
                  :status=>"True",
                  :type=>"LiveMigratable"
                },
                {
                  :lastProbeTime=>nil,
                  :lastTransitionTime=>"2019-04-02T13:46:24Z",
                  :status=>"True",
                  :type=>"Ready"
                }
              ],
              :interfaces=>[
                {
                  :ipAddress=>"10.244.1.14",
                  :mac=>"0e:fc:6c:c3:20:ec",
                  :name=>"default"
                },
                {
                  :mac=>"4a:90:1c:2e:fe:d7",
                  :name=>"ptp"
                }
              ],
              :migrationMethod=>"BlockMigration",
              :nodeName=>"node02",
              :phase=>"Running",
            }
          }
          Vminstance.parse object_to_hash(vm)
        end
      end
    end
  end
end
