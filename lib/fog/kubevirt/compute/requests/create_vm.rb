module Fog
  module Kubevirt
    class Compute
      class Real
        def create_vm(vm)
          vm[:apiVersion] = kubevirt_client.version

          kubevirt_client.create_virtual_machine(vm)
        rescue ::Fog::Kubevirt::Errors::ClientError => err
          log.warn(err)
          raise ::Fog::Kubevirt::Errors::AlreadyExistsError
        end
      end

      class Mock
        def create_vm(vm)
          args_network_based ={:kind=>"VirtualMachine",
                               :metadata=>{:labels=>{:"kubevirt.io/vm"=>"robin-rykert.example.com"},
                                           :name=>"robin-rykert.example.com",
                                           :namespace=>"default"},
                                           :spec=>{:running=>false,
                                                   :template=>{:metadata=>{:creationTimestamp=>nil,
                                                                           :labels=>{:"kubevirt.io/vm"=>"robin-rykert.example.com"}},
          :spec=>{:domain=>{:devices=>{:disks=>[{:name=>"robin-rykert-example-com-disk-00",
                                                 :disk=>{:bus=>"virtio"}},
          {:name=>"robin-rykert-example-com-disk-01",
           :disk=>{:bus=>"virtio"}}],
          :interfaces=>[{:bridge=>{},
                         :name=>"ovs-foreman",
                         :bootOrder=>1,
                         :macAddress=>"a2:b4:a2:b6:a2:a8"}]},
                         :machine=>{:type=>""},
                         :resources=>{:requests=>{:memory=>"1024M"}},
                         :cpu=>{:cores=>1}},
          :terminationGracePeriodSeconds=>0,
          :volumes=>[{:name=>"robin-rykert-example-com-disk-00",
                      :persistentVolumeClaim=>{:claimName=>"robin-rykert-example-com-claim-1"}},
          {:name=>"robin-rykert-example-com-disk-01",
           :persistentVolumeClaim=>{:claimName=>"robin-rykert-example-com-claim-2"}}],
          :networks=>[{:name=>"ovs-foreman",
                       :multus=>{:networkName=>"ovs-foreman"}}]}}}}
          if vm == args_network_based
            result = Kubeclient::Resource.new
            result.apiVersion="kubevirt.io/v1alpha3"
            result.kind="VirtualMachine"
            result.metadata={:creationTimestamp=>"2019-04-06T14:05:15Z",
                             :generation=>1,
                             :labels=>{:"kubevirt.io/vm"=>"robin-rykert.example.com"},
                             :name=>"robin-rykert.example.com",
                             :namespace=>"default",
                             :resourceVersion=>"1020275",
                             :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/robin-rykert.example.com",
                             :uid=>"00ae63ee-5875-11e9-9132-525400c5a686"}
            result.spec={:running=>false,
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

          args_image_based = {:kind=>"VirtualMachine",
                              :metadata=>{:labels=>{:"kubevirt.io/vm"=>"olive-kempter.example.com"},
                                          :name=>"olive-kempter.example.com",
                                          :namespace=>"default"},
                                          :spec=>{:running=>false,
                                                  :template=>{:metadata=>{:creationTimestamp=>nil,
                                                                          :labels=>{:"kubevirt.io/vm"=>"olive-kempter.example.com"}},
          :spec=>{:domain=>{:devices=>{:disks=>[{:name=>"olive-kempter-example-com-disk-00",
                                                 :disk=>{:bus=>"virtio"},
                                                 :bootOrder=>1},
                                                 {:name=>"olive-kempter-example-com-disk-01",
                                                  :disk=>{:bus=>"virtio"}}],
          :interfaces=>[{:bridge=>{},
                         :name=>"ovs-foreman",
                         :macAddress=>"a2:a4:a2:b2:a2:b6"}]},
                         :machine=>{:type=>""},
                         :resources=>{:requests=>{:memory=>"1024M"}},
                         :cpu=>{:cores=>1}},
          :terminationGracePeriodSeconds=>0,
          :volumes=>[{:name=>"olive-kempter-example-com-disk-00",
                      :containerDisk=>{:image=>"kubevirt/fedora-cloud-registry-disk-demo"}},
          {:name=>"olive-kempter-example-com-disk-01",
           :persistentVolumeClaim=>{:claimName=>"olive-kempter-example-com-claim-1"}}],
          :networks=>[{:name=>"ovs-foreman",
                       :multus=>{:networkName=>"ovs-foreman"}}]}}}}
          if vm == args_image_based
            result = Kubeclient::Resource.new
            result.apiVersion="kubevirt.io/v1alpha3"
            result.kind = "VirtualMachine"
            result.metadata={:creationTimestamp=>"2019-04-07T15:00:07Z",
                             :generation=>1,
                             :labels=>{:"kubevirt.io/vm"=>"olive-kempter.example.com"},
                             :name=>"olive-kempter.example.com",
                             :namespace=>"default",
                             :resourceVersion=>"1075555",
                             :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/olive-kempter.example.com",
                             :uid=>"d4dba9e4-5945-11e9-9132-525400c5a686"},
                             result.spec={:running=>false,
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
          end
        end
      end
    end
  end
end
