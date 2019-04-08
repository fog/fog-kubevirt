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
          if vm == {:kind=>"VirtualMachine", :metadata=>{:labels=>{:"kubevirt.io/vm"=>"norma-huish.example.com"}, :name=>"norma-huish.example.com", :namespace=>"default"}, :spec=>{:running=>false, :template=>{:metadata=>{:creationTimestamp=>nil, :labels=>{:"kubevirt.io/vm"=>"norma-huish.example.com"}}, :spec=>{:domain=>{:devices=>{:disks=>[{:name=>"norma-huish-example-com-disk-00", :disk=>{:bus=>"virtio"}, :bootOrder=>1}], :interfaces=>[{:bridge=>{}, :name=>"ovs-foreman", :bootOrder=>2, :macAddress=>"a2:a4:b4:a8:a6:a6"}]}, :machine=>{:type=>""}, :resources=>{:requests=>{:memory=>"1024M"}}, :cpu=>{:cores=>1}}, :terminationGracePeriodSeconds=>0, :volumes=>[{:name=>"norma-huish-example-com-disk-00", :persistentVolumeClaim=>{:claimName=>"claimski1"}}], :networks=>[{:name=>"ovs-foreman", :multus=>{:networkName=>"ovs-foreman"}}]}}}}
            result = Kubeclient::Resource.new()
            result.apiVersion = "kubevirt.io/v1alpha3"
            result.kind = "VirtualMachine"
            result.metadata = {:creationTimestamp=>"2019-04-03T09:00:38Z", :generation=>1, :labels=>{:"kubevirt.io/vm"=>"norma-huish.example.com"}, :name=>"norma-huish.example.com", :namespace=>"default", :resourceVersion=>"887626", :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/norma-huish.example.com", :uid=>"f38cdc0a-55ee-11e9-9132-525400c5a686"}
            result.spec = {:running=>false, :template=>{:metadata=>{:creationTimestamp=>nil, :labels=>{:"kubevirt.io/vm"=>"norma-huish.example.com"}}, :spec=>{:domain=>{:cpu=>{:cores=>1}, :devices=>{:disks=>[{:bootOrder=>1, :disk=>{:bus=>"virtio"}, :name=>"norma-huish-example-com-disk-00"}], :interfaces=>[{:bootOrder=>2, :bridge=>{}, :macAddress=>"a2:a4:b4:a8:a6:a6", :name=>"ovs-foreman"}]}, :machine=>{:type=>""}, :resources=>{:requests=>{:memory=>"1024M"}}}, :networks=>[{:multus=>{:networkName=>"ovs-foreman"}, :name=>"ovs-foreman"}], :terminationGracePeriodSeconds=>0, :volumes=>[{:name=>"norma-huish-example-com-disk-00", :persistentVolumeClaim=>{:claimName=>"claimski1"}}]}}}
            return result
          end

          if vm == {:kind=>"VirtualMachine", :metadata=>{:labels=>{:"kubevirt.io/vm"=>"blake-istre.example.com"}, :name=>"blake-istre.example.com", :namespace=>"default"}, :spec=>{:running=>false, :template=>{:metadata=>{:creationTimestamp=>nil, :labels=>{:"kubevirt.io/vm"=>"blake-istre.example.com"}}, :spec=>{:domain=>{:devices=>{:disks=>[{:name=>"blake-istre-example-com-disk-00", :disk=>{:bus=>"virtio"}}], :interfaces=>[{:bridge=>{}, :name=>"ovs-foreman", :bootOrder=>1, :macAddress=>"a2:a4:b6:a4:a2:a8"}]}, :machine=>{:type=>""}, :resources=>{:requests=>{:memory=>"1024M"}}, :cpu=>{:cores=>1}}, :terminationGracePeriodSeconds=>0, :volumes=>[{:name=>"blake-istre-example-com-disk-00", :containerDisk=>{:image=>"kubevirt/fedora-cloud-registry-disk-demo"}}], :networks=>[{:name=>"ovs-foreman", :multus=>{:networkName=>"ovs-foreman"}}]}}}}
            result = Kubeclient::Resource.new()
            result.apiVersion = "kubevirt.io/v1alpha3"
            result.kind = "VirtualMachine"
            result.metadata = {:creationTimestamp=>"2019-04-04T05:50:37Z", :generation=>1, :labels=>{:"kubevirt.io/vm"=>"blake-istre.example.com"}, :name=>"blake-istre.example.com", :namespace=>"default", :resourceVersion=>"963318", :selfLink=>"/apis/kubevirt.io/v1alpha3/namespaces/default/virtualmachines/blake-istre.example.com", :uid=>"926c9aa4-569d-11e9-9132-525400c5a686"}
            result.spec = {:running=>false, :template=>{:metadata=>{:creationTimestamp=>nil, :labels=>{:"kubevirt.io/vm"=>"blake-istre.example.com"}}, :spec=>{:domain=>{:cpu=>{:cores=>1}, :devices=>{:disks=>[{:disk=>{:bus=>"virtio"}, :name=>"blake-istre-example-com-disk-00"}], :interfaces=>[{:bootOrder=>1, :bridge=>{}, :macAddress=>"a2:a4:b6:a4:a2:a8", :name=>"ovs-foreman"}]}, :machine=>{:type=>""}, :resources=>{:requests=>{:memory=>"1024M"}}}, :networks=>[{:multus=>{:networkName=>"ovs-foreman"}, :name=>"ovs-foreman"}], :terminationGracePeriodSeconds=>0, :volumes=>[{:containerDisk=>{:image=>"kubevirt/fedora-cloud-registry-disk-demo"}, :name=>"blake-istre-example-com-disk-00"}]}}}
            return result
          end
        end
      end
    end
  end
end
