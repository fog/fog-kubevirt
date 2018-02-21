require 'recursive_open_struct'

module Fog
  module Compute
    class Kubevirt
      class Real
        def list_templates(_filters = {})
          client.get_templates(namespace: 'default').map { |kubevirt_obj| Template.parse object_to_hash(kubevirt_obj) }
        end
      end

      class Mock
        def list_templates(_filters = {})
          templates = [{ apiVersion: 'kubevirt.io/v1alpha1',
                         kind: 'Template',
                         metadata: { annotations: { description: 'OCP kubevirt linux, template', tags: 'kubevirt,ocp,template,linux' },
                                     clusterName: '',
                                     creationTimestamp: '2018-02-07T11:50:42Z',
                                     labels: { :"miq.github.io/kubevirt-is-vm-template" => true, :"miq.github.io/kubevirt-os" => 'rhel-7' },
                                     name: 'working',
                                     namespace: 'default',
                                     resourceVersion: '768372',
                                     selfLink: '/apis/kubevirt.io/v1alpha1/namespaces/default/templates/working',
                                     uid: '200bc21c-0bfd-11e8-a490-525400b2cba8' },
                         spec: { template: { spec:   { domain: { cpu: { cores: 4 },
                                                                 devices: { disks: [{ disk: { dev: 'vda' }, name: 'disk0', volumeName: 'disk0-pvc' }] },
                                                                 machine: { type: 'q35' },
                                                                 resources: { requests: { memory: '512Mi' } } },
                                                       volumes: [{ name: 'disk0-pvc', persistentVolumeClaim: { claimName: 'linux-vm-pvc-test' } }] } } } }]
          object = RecursiveOpenStruct.new(templates, recurse_over_arrays: true)
          object.map { |kubevirt_obj| Template.parse object_to_hash(kubevirt_obj) }
        end
      end
    end
  end
end
