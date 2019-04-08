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
          update_args = {:apiVersion=>"kubevirt.io/v1alpha3",
                         :kind=>"VirtualMachine",
                         :metadata=>{:creationTimestamp=>"2019-04-06T14:05:15Z",
                                     :generation=>1,
                                     :labels=>{:"kubevirt.io/vm"=>"robin-rykert.example.com"},
                                     :name=>"robin-rykert.example.com",
                                     :namespace=>"default",
                                     :resourceVersion=>"1020275",
                                     :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/robin-rykert.example.com",
                                     :uid=>"00ae63ee-5875-11e9-9132-525400c5a686"},
                                     :spec=>{:running=>true,
                                             :template=>{:metadata=>{:creationTimestamp=>nil,
                                                                     :labels=>{:"kubevirt.io/vm"=>"robin-rykert.example.com"}},
          :spec=>{:domain=>{:cpu=>{:cores=>1},
                            :devices=>{:disks=>[{:disk=>{:bus=>"virtio"},
                                                 :name=>"robin-rykert-example-com-disk-00"},
                                                 {:disk=>{:bus=>"virtio"},
                                                  :name=>"robin-rykert-example-com-disk-01"}],
                                                  :interfaces=>[{:bootOrder=>1,
                                                                 :bridge=>{},
                                                                 :macAddress=>"a2:b4:a2:b6:a2:a8",
                                                                 :name=>"ovs-foreman"}]},
                                                                 :machine=>{:type=>""},
                                                                 :resources=>{:requests=>{:memory=>"1024M"}}},
          :networks=>[{:multus=>{:networkName=>"ovs-foreman"},
                       :name=>"ovs-foreman"}],
                       :terminationGracePeriodSeconds=>0,
                       :volumes=>[{:name=>"robin-rykert-example-com-disk-00",
                                   :persistentVolumeClaim=>{:claimName=>"robin-rykert-example-com-claim-1"}},
          {:name=>"robin-rykert-example-com-disk-01",
           :persistentVolumeClaim=>{:claimName=>"robin-rykert-example-com-claim-2"}}]}}}}
          if update == update_args
            result = Kubeclient::Resource.new
            result.apiVersion="kubevirt.io/v1alpha3"
            result.kind="VirtualMachine"
            result.metadata={:creationTimestamp=>"2019-04-06T14:05:15Z",
                             :generation=>2,
                             :labels=>{:"kubevirt.io/vm"=>"robin-rykert.example.com"},
                             :name=>"robin-rykert.example.com",
                             :namespace=>"default",
                             :resourceVersion=>"1020276",
                             :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/robin-rykert.example.com",
                             :uid=>"00ae63ee-5875-11e9-9132-525400c5a686"}
            result.spec={:running=>true,
                         :template=>{:metadata=>{:creationTimestamp=>nil,
                                                 :labels=>{:"kubevirt.io/vm"=>"robin-rykert.example.com"}},
            :spec=>{:domain=>{:cpu=>{:cores=>1},
                              :devices=>{:disks=>[{:disk=>{:bus=>"virtio"},
                                                   :name=>"robin-rykert-example-com-disk-00"},
                                                   {:disk=>{:bus=>"virtio"},
                                                    :name=>"robin-rykert-example-com-disk-01"}],
                                                    :interfaces=>[{:bootOrder=>1,
                                                                   :bridge=>{},
                                                                   :macAddress=>"a2:b4:a2:b6:a2:a8",
                                                                   :name=>"ovs-foreman"}]},
                                                                   :machine=>{:type=>""},
                                                                   :resources=>{:requests=>{:memory=>"1024M"}}},
            :networks=>[{:multus=>{:networkName=>"ovs-foreman"},
                         :name=>"ovs-foreman"}],
                         :terminationGracePeriodSeconds=>0,
                         :volumes=>[{:name=>"robin-rykert-example-com-disk-00",
                                     :persistentVolumeClaim=>{:claimName=>"robin-rykert-example-com-claim-1"}},
            {:name=>"robin-rykert-example-com-disk-01",
             :persistentVolumeClaim=>{:claimName=>"robin-rykert-example-com-claim-2"}}]}}}
            return result
          end

          update_args_olive = {:apiVersion=>"kubevirt.io/v1alpha3",
                              :kind=>"VirtualMachine",
                              :metadata=>{:creationTimestamp=>"2019-04-07T15:00:07Z",
                                          :generation=>1,
                                          :labels=>{:"kubevirt.io/vm"=>"olive-kempter.example.com"},
                                          :name=>"olive-kempter.example.com",
                                          :namespace=>"default",
                                          :resourceVersion=>"1075555",
                                          :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/olive-kempter.example.com",
                                          :uid=>"d4dba9e4-5945-11e9-9132-525400c5a686"},
                                          :spec=>{:running=>true,
                                                  :template=>{:metadata=>{:creationTimestamp=>nil,
                                                                          :labels=>{:"kubevirt.io/vm"=>"olive-kempter.example.com"}},
          :spec=>{:domain=>{:cpu=>{:cores=>1},
                            :devices=>{:disks=>[{:bootOrder=>1,
                                                 :disk=>{:bus=>"virtio"},
                                                 :name=>"olive-kempter-example-com-disk-00"},
                                                 {:disk=>{:bus=>"virtio"},
                                                  :name=>"olive-kempter-example-com-disk-01"}],
                                                  :interfaces=>[{:bridge=>{},
                                                                 :macAddress=>"a2:a4:a2:b2:a2:b6",
                                                                 :name=>"ovs-foreman"}]},
                                                                 :machine=>{:type=>""},
                                                                 :resources=>{:requests=>{:memory=>"1024M"}}},
          :networks=>[{:multus=>{:networkName=>"ovs-foreman"},
                       :name=>"ovs-foreman"}],
                       :terminationGracePeriodSeconds=>0,
                       :volumes=>[{:containerDisk=>{:image=>"kubevirt/fedora-cloud-registry-disk-demo"},
                                   :name=>"olive-kempter-example-com-disk-00"},
                                   {:name=>"olive-kempter-example-com-disk-01",
                                    :persistentVolumeClaim=>{:claimName=>"olive-kempter-example-com-claim-1"}}]}}}}

          if update == update_args_olive
            result = Kubeclient::Resource.new
            result.apiVersion="kubevirt.io/v1alpha3"
            result.kind="VirtualMachine"
            result.metadata={:creationTimestamp=>"2019-04-07T15:00:07Z",
                             :generation=>2,
                             :labels=>{:"kubevirt.io/vm"=>"olive-kempter.example.com"},
                             :name=>"olive-kempter.example.com",
                             :namespace=>"default",
                             :resourceVersion=>"1075556",
                             :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/olive-kempter.example.com",
                             :uid=>"d4dba9e4-5945-11e9-9132-525400c5a686"}
            result.spec={:running=>true,
                         :template=>{:metadata=>{:creationTimestamp=>nil,
                                                 :labels=>{:"kubevirt.io/vm"=>"olive-kempter.example.com"}},
            :spec=>{:domain=>{:cpu=>{:cores=>1},
                              :devices=>{:disks=>[{:bootOrder=>1,
                                                   :disk=>{:bus=>"virtio"},
                                                   :name=>"olive-kempter-example-com-disk-00"},
                                                   {:disk=>{:bus=>"virtio"},
                                                    :name=>"olive-kempter-example-com-disk-01"}],
                                                    :interfaces=>[{:bridge=>{},
                                                                   :macAddress=>"a2:a4:a2:b2:a2:b6",
                                                                   :name=>"ovs-foreman"}]},
                                                                   :machine=>{:type=>""},
                                                                   :resources=>{:requests=>{:memory=>"1024M"}}},
            :networks=>[{:multus=>{:networkName=>"ovs-foreman"},
                         :name=>"ovs-foreman"}],
                         :terminationGracePeriodSeconds=>0,
                         :volumes=>[{:containerDisk=>{:image=>"kubevirt/fedora-cloud-registry-disk-demo"},
                                     :name=>"olive-kempter-example-com-disk-00"},
                                     {:name=>"olive-kempter-example-com-disk-01",
                                      :persistentVolumeClaim=>{:claimName=>"olive-kempter-example-com-claim-1"}}]}}}
            return result
          end
        end
      end
    end
  end
end
