module Fog
  module Kubevirt
    class Compute
      class Real
        def update_vm(update)
          kubevirt_client.update_virtual_machine(update)
        end
      end

      class Mock
        def update_vm(update)
          byebug
          update_vm_params = {:apiVersion=>"kubevirt.io/v1alpha3",
                              :kind=>"VirtualMachine",
                              :metadata=>{:creationTimestamp=>"2019-04-03T09:00:38Z",
                                          :generation=>1,
                                          :labels=>{:"kubevirt.io/vm"=>"norma-huish.example.com"},
                                          :name=>"norma-huish.example.com",
                                          :namespace=>"default",
                                          :resourceVersion=>"887626",
                                          :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/norma-huish.example.com",
                                          :uid=>"f38cdc0a-55ee-11e9-9132-525400c5a686"},
                                          :spec=>{:running=>true,
                                                  :template=>{:metadata=>{:creationTimestamp=>nil,
                                                                          :labels=>{:"kubevirt.io/vm"=>"norma-huish.example.com"}},
          :spec=>{:domain=>{:cpu=>{:cores=>1},
                            :devices=>{:disks=>[{:bootOrder=>1,
                                                 :disk=>{:bus=>"virtio"},
                                                 :name=>"norma-huish-example-com-disk-00"}],
                                                 :interfaces=>[{:bootOrder=>2,
                                                                :bridge=>{},
                                                                :macAddress=>"a2:a4:b4:a8:a6:a6",
                                                                :name=>"ovs-foreman"}]},
                                                                :machine=>{:type=>""},
                                                                :resources=>{:requests=>{:memory=>"1024M"}}},
          :networks=>[{:multus=>{:networkName=>"ovs-foreman"},
                       :name=>"ovs-foreman"}],
                       :terminationGracePeriodSeconds=>0,
                       :volumes=>[{:name=>"norma-huish-example-com-disk-00",
                                   :persistentVolumeClaim=>{:claimName=>"claimski1"}}]}}}}
          if update == update_vm_params
            vm_resource = Kubeclient::Resource.new
            vm_resource.apiVersion = "kubevirt.io/v1alpha3"
            vm_resource.kind = "VirtualMachine"
            vm_resource.metadata = {:creationTimestamp=>"2019-04-03T09:00:38Z", :generation=>2, :labels=>{:"kubevirt.io/vm"=>"norma-huish.example.com"}, :name=>"norma-huish.example.com", :namespace=>"default", :resourceVersion=>"887627", :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/norma-huish.example.com", :uid=>"f38cdc0a-55ee-11e9-9132-525400c5a686"}
            vm_resource.spec = {:running=>true, :template=>{:metadata=>{:creationTimestamp=>nil, :labels=>{:"kubevirt.io/vm"=>"norma-huish.example.com"}}, :spec=>{:domain=>{:cpu=>{:cores=>1}, :devices=>{:disks=>[{:bootOrder=>1, :disk=>{:bus=>"virtio"}, :name=>"norma-huish-example-com-disk-00"}], :interfaces=>[{:bootOrder=>2, :bridge=>{}, :macAddress=>"a2:a4:b4:a8:a6:a6", :name=>"ovs-foreman"}]}, :machine=>{:type=>""}, :resources=>{:requests=>{:memory=>"1024M"}}}, :networks=>[{:multus=>{:networkName=>"ovs-foreman"}, :name=>"ovs-foreman"}], :terminationGracePeriodSeconds=>0, :volumes=>[{:name=>"norma-huish-example-com-disk-00", :persistentVolumeClaim=>{:claimName=>"claimski1"}}]}}}
            return vm_resource
          end

          update_vm_params_image = {:apiVersion=>"kubevirt.io/v1alpha3",
                                    :kind=>"VirtualMachine",
                                    :metadata=>{:creationTimestamp=>"2019-04-04T05:50:37Z",
                                                :generation=>1,
                                                :labels=>{:"kubevirt.io/vm"=>"blake-istre.example.com"},
                                                :name=>"blake-istre.example.com",
                                                :namespace=>"default",
                                                :resourceVersion=>"963318",
                                                :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/blake-istre.example.com",
                                                :uid=>"926c9aa4-569d-11e9-9132-525400c5a686"},
                                                :spec=>{:running=>true,
                                                        :template=>{:metadata=>{:creationTimestamp=>nil,
                                                                                :labels=>{:"kubevirt.io/vm"=>"blake-istre.example.com"}},
          :spec=>{:domain=>{:cpu=>{:cores=>1},
                            :devices=>{:disks=>[{:disk=>{:bus=>"virtio"},
                                                 :name=>"blake-istre-example-com-disk-00"}],
                                                 :interfaces=>[{:bootOrder=>1,
                                                                :bridge=>{},
                                                                :macAddress=>"a2:a4:b6:a4:a2:a8",
                                                                :name=>"ovs-foreman"}]},
                                                                :machine=>{:type=>""},
                                                                :resources=>{:requests=>{:memory=>"1024M"}}},
          :networks=>[{:multus=>{:networkName=>"ovs-foreman"},
                       :name=>"ovs-foreman"}],
                       :terminationGracePeriodSeconds=>0,
                       :volumes=>[{:containerDisk=>{:image=>"kubevirt/fedora-cloud-registry-disk-demo"},
                                   :name=>"blake-istre-example-com-disk-00"}]}}}}

           if update == update_vm_params_image
            vm_resource = Kubeclient::Resource.new
            vm_resource.apiVersion = "kubevirt.io/v1alpha3"
            vm_resource.kind = "VirtualMachine"
            vm_resource.metadata = {:creationTimestamp=>"2019-04-04T05:50:37Z", :generation=>2, :labels=>{:"kubevirt.io/vm"=>"blake-istre.example.com"}, :name=>"blake-istre.example.com", :namespace=>"default", :resourceVersion=>"963319", :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/blake-istre.example.com", :uid=>"926c9aa4-569d-11e9-9132-525400c5a686"}
            vm_resource.spec = {:running=>true, :template=>{:metadata=>{:creationTimestamp=>nil, :labels=>{:"kubevirt.io/vm"=>"blake-istre.example.com"}}, :spec=>{:domain=>{:cpu=>{:cores=>1}, :devices=>{:disks=>[{:disk=>{:bus=>"virtio"}, :name=>"blake-istre-example-com-disk-00"}], :interfaces=>[{:bootOrder=>1, :bridge=>{}, :macAddress=>"a2:a4:b6:a4:a2:a8", :name=>"ovs-foreman"}]}, :machine=>{:type=>""}, :resources=>{:requests=>{:memory=>"1024M"}}}, :networks=>[{:multus=>{:networkName=>"ovs-foreman"}, :name=>"ovs-foreman"}], :terminationGracePeriodSeconds=>0, :volumes=>[{:containerDisk=>{:image=>"kubevirt/fedora-cloud-registry-disk-demo"}, :name=>"blake-istre-example-com-disk-00"}]}}}
            return vm_resource
           end
        end
      end
    end
  end
end
