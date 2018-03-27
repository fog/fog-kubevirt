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
