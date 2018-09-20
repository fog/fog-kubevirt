require 'recursive_open_struct'

module Fog
  module Kubevirt
    class Compute
      class Real
        def list_templates(_filters = {})
          temps = openshift_client.get_templates(namespace: @namespace)
          entities = temps.map do |kubevirt_obj|
            Template.parse object_to_hash(kubevirt_obj)
          end
          EntityCollection.new(temps.kind, temps.resourceVersion, entities)
        end
      end

      class Mock
        def list_templates(_filters = {})
          templates = [{ metadata: { name: 'linux-vm-template',
                                     namespace: 'default',
                                     selfLink: '/oapi/v1/namespaces/default/templates/linux-vm-template',
                                     uid: '610c434f-17bc-11e8-a9f9-525400a7f647',
                                     resourceVersion: '9240',
                                     creationTimestamp: '2018-02-22T10:37:28Z',
                                     labels: { :"miq.github.io/kubevirt-is-vm-template" => 'true',
                                               :"miq.github.io/kubevirt-os" => 'rhel-7' },
                                               annotations: { description: 'OCP kubevirt linux, template',
                                                              tags: 'kubevirt,ocp,template,linux' }
                                   },
                                                              objects: [{ apiVersion: 'kubevirt.io/v1alpha2',
                                                                          kind: 'VirtualMachine',
                                                                          metadata: { name: '${NAME}' },
                                                                          spec: { template: { spec: { domain:
                                                                                                      { cpu: { cores: '${CPU_CORES}' },
                                                                                                        devices: { disks: [{ disk: { dev: 'vda' }, name: 'disk0', volumeName: 'disk0-pvc' }] },
                                                                                                        machine: { type: 'q35' },
                                                                                                        resources: { requests: { memory: '${MEMORY}' } } },
          volumes: [{ name: 'disk0-pvc', persistentVolumeClaim: { claimName: 'linux-vm-pvc-${NAME}' } }] } } } },
          { apiVersion: 'v1',
            kind: 'PersistentVolumeClaim',
            metadata: { name: 'linux-vm-pvc-${NAME}' },
            spec: { accessModes: ['ReadWriteOnce'],
                    resources: { requests: { storage: '10Gi' } } } }],
          parameters: [{ name: 'NAME', description: 'Name for the new VM' },
                       { name: 'MEMORY', description: 'Amount of memory', value: '4096Mi' },
                       { name: 'CPU_CORES', description: 'Amount of cores', value: '4' }] }]
          object = RecursiveOpenStruct.new(templates, recurse_over_arrays: true)
          object.map { |kubevirt_obj| Template.parse object_to_hash(kubevirt_obj) }
        end
      end
    end
  end
end
