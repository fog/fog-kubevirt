require 'recursive_open_struct'

module Fog
  module Compute
    class Kubevirt
      class Real
        def list_offlinevms(_filters = {})
          client.get_offline_virtual_machines(namespace: 'default').map { |kubevirt_obj| Offlinevm.parse object_to_hash(kubevirt_obj) }
        end
      end

      class Mock
        def list_offlinevms(_filters = {})
          offlinevms = [{ apiVersion: 'kubevirt.io/v1alpha1',
                          kind: 'OfflineVirtualMachine',
                          metadata: {
                            clusterName: '',
                            creationTimestamp: '2018-02-21T11:15:41Z',
                            name: 'aaa',
                            namespace: 'default',
                            resourceVersion: '967810',
                            selfLink: '/apis/kubevirt.io/v1alpha1/namespaces/default/offlinevirtualmachines/aaa',
                            uid: '8d27ad76-16f8-11e8-95dc-525400b2cba8'
                          },
                          spec: {
                            template: {
                              spec: { domain: { cpu: { cores: 4 },
                                                devices: { disks: [{ disk: { dev: 'vda' },
                                                                     name: 'registrydisk',
                                                                     volumeName: 'registryvolume' },
                                                                   { disk: { dev: 'vdb' },
                                                                     name: 'cloudinitdisk',
                                                                     volumeName: 'cloudinitvolume' }] },
                                                machine: { type: 'q35' },
                                                resources: { requests: { memory: '512Mi' } } },
                                      volumes: [{ name: 'registryvolume',
                                                  registryDisk: { image: 'kubevirt/fedora-cloud-registry-disk-demo:latest' } },
                                                { cloudInitNoCloud: { userDataBase64: 'I2Nsb3VkLWNvbmZpZwpwYXNzd29yZDogYXRvbWljCnNzaF9wd2F1dGg6IFRydWUKY2hwYXNzd2Q6IHsgZXhwaXJlOiBGYWxzZSB9Cg==' },
                                                  name: 'cloudinitvolume' }] }
                            }
                          } }]
          object = RecursiveOpenStruct.new(offlinevms, recurse_over_arrays: true)
          object.map { |kubevirt_obj| Offlinevm.parse object_to_hash(kubevirt_obj) }
        end
      end
    end
  end
end
