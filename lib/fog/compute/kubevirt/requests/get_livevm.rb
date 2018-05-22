require 'recursive_open_struct'

module Fog
  module Compute
    class Kubevirt
      class Real
        def get_livevm(name)
          # namespace is defined on the Real object
          Livevm.parse object_to_hash( kubevirt_client.get_virtual_machine(name, @namespace) )
        end
      end

      class Mock
        def get_livevm(name)
          vm = { :apiVersion => "kubevirt.io/v1alpha1",
                 :kind       => "VirtualMachine",
                 :metadata   => { :clusterName       => "",
                                  :creationTimestamp => "2018-02-23T10:12:47Z",
                                  :name              => "demo",
                                  :namespace         => "default",
                                  :ownerReferences   => [{ :apiVersion      => "kubevirt.io/v1alpha1",
                                                           :kind            => "OfflineVirtualMachine",
                                                           :name            => "demo",
                                                           :uid             => "57e279c1-17ee-11e8-a9f9-525400a7f647"
                                                         }
                                                        ],
                                  :resourceVersion   => "84873",
                                  :selfLink          => "/apis/kubevirt.io/v1alpha1/namespaces/default/virtualmachines/demo",
                                  :uid               => "1906421f-1882-11e8-b539-525400a7f647"
                                },
                 :spec       => { :domain => { :cpu     => { :cores => "4" },
                                               :devices => { :disks => [{ :disk       => { :dev => "vda" },
                                                                          :name       => "registrydisk",
                                                                          :volumeName => "registryvolume"
                                                                        },
                                                                        { :disk       => { :dev => "vdb" },
                                                                          :name       => "cloudinitdisk",
                                                                          :volumeName => "cloudinitvolume"
                                                                        }
                                                                       ]
                                                           },
                                               :machine    => { :type => "q35" },
                                               :resources  => { :requests => { :memory => "512Mi" }}
                                             },
                                  :volumes => [ { :name         => "registryvolume",
                                                  :registryDisk => { :image => "kubevirt/fedora-cloud-registry-disk-demo:latest" }
                                                },
                                                { :cloudInitNoCloud => { :userDataBase64 => "I2Nsb3VkLWNvbmZpZwpwYXNzd29yZDogYXRvbWljCnNzaF9wd2F1dGg6IFRydWUKY2hwYXNzd2Q6IHsgZXhwaXJlOiBGYWxzZSB9Cg==" },
                                                  :name             => "cloudinitvolume"
                                                }
                                              ]
                                  }
               }
          object = RecursiveOpenStruct.new(vm, recurse_over_arrays: true)
          Livevm.parse object_to_hash(object)
        end
      end
    end
  end
end
