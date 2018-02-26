module Fog
  module Compute
    class Kubevirt
      class Offlinevm < Fog::Model
        identity :name

        attribute :namespace,        :aliases => 'metadata_namespace'
        attribute :resource_version, :aliases => 'metadata_resource_version'
        attribute :uid,              :aliases => 'metadata_uid'
        attribute :cpu_cores,        :aliases => 'spec_cpu_cores'
        attribute :memory,           :aliases => 'spec_memory'
        attribute :disks,            :aliases => 'spec_disks'
        attribute :volumes,          :aliases => 'spec_volumes'


        def start(options = {})
          # Change the `running` attribute to `true` so that the offline virtual machine controller will take it and create
          # the live virtual machine.
          offline_vm = service.get_raw_offlinevm(name)
          offline_vm = offline_vm.deep_merge(
            :spec => {
              :running => true
            }
          )
          service.update_offline_vm(offline_vm)

          # TODO: We need to create the live virtual machine explicitly because KubeVirt still doesn't have a controller
          # that starts automatically the virtual machines when the `running` attribute is changed to `true`. This should be
          # removed when that controller is added.
          live_vm = {
            :metadata => {
              :namespace       => namespace,
              :name            => name,
              :ownerReferences => [{
                :apiVersion => offline_vm[:apiVersion],
                :kind       => offline_vm[:kind],
                :name       => offline_vm[:metadata][:name],
                :uid        => uid
              }]
            },
            :spec     => offline_vm[:spec][:template][:spec]
          }

          # make sure to copy vm presets
          unless offline_vm[:metadata][:selector].nil?
            live_vm = live_vm.deep_merge(
              :metadata => {
                :namespace => {
                  :selector => offline_vm[:metadata][:selector]
                }
              }
            )
          end

          service.create_vm(live_vm)
        end

        def stop(options = {})
        end

        def self.parse(object)
          metadata = object[:metadata]
          spec = object[:spec][:template][:spec]
          domain = spec[:domain]
          {
            :namespace        => metadata[:namespace],
            :name             => metadata[:name],
            :resource_version => metadata[:resourceVersion],
            :uid              => metadata[:uid],
            :cpu_cores        => domain[:cpu][:cores],
            :memory           => domain[:resources][:requests][:memory],
            :disks            => domain[:devices][:disks],
            :volumes          => spec[:volumes]
          }
        end
      end
    end
  end
end
