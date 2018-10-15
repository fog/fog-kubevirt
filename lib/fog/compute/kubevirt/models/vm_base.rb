module Fog
  module Compute
    class Kubevirt
      module VmBase
        def define_properties
          identity :name

          attribute :namespace,        :aliases => 'metadata_namespace'
          attribute :resource_version, :aliases => 'metadata_resource_version'
          attribute :uid,              :aliases => 'metadata_uid'
          attribute :labels,           :aliases => 'metadata_labels'
          attribute :owner_reference,  :aliases => 'metadata_owner_reference'
          attribute :annotations,      :aliases => 'metadata_annotations'
          attribute :cpu_cores,        :aliases => 'spec_cpu_cores'
          attribute :memory,           :aliases => 'spec_memory'
          attribute :disks,            :aliases => 'spec_disks'
          attribute :volumes,          :aliases => 'spec_volumes'
          attribute :status,           :aliases => 'spec_running'
        end

        def parse_object(object)
          metadata = object[:metadata]
          spec = object[:spec][:template][:spec]
          domain = spec[:domain]
          owner = metadata[:ownerReferences]
          annotations = metadata[:annotations]
          cpu = domain[:cpu]
          mem = domain.dig(:resources, :requests, :memory)
          vm = {
            :namespace        => metadata[:namespace],
            :name             => metadata[:name],
            :resource_version => metadata[:resourceVersion],
            :uid              => metadata[:uid],
            :labels           => metadata[:labels],
            :disks            => domain[:devices][:disks],
            :volumes          => spec[:volumes],
            :state            => object[:spec][:running].to_s == "true" ? "running" : "stopped",
          }
          vm[:owner_reference] = owner unless owner.nil?
          vm[:annotations] = annotations unless annotations.nil?
          vm[:cpu_cores] = cpu[:cores] unless cpu.nil?
          vm[:memory] = mem unless mem.nil?

          vm
        end
      end

      module VmAction
        def start(options = {})
          # Change the `running` attribute to `true` so that the virtual machine controller will take it and
          # create the virtual machine instance.
          vm = service.get_raw_vm(name)
          vm = deep_merge!(vm,
            :spec => {
              :running => true
            }
          )
          service.update_vm(vm)
        end

        def stop(options = {})
          vm = service.get_raw_vm(name)
          vm = deep_merge!(vm,
            :spec => {
              :running => false
            }
          )
          service.update_vm(vm)
        end
      end
    end
  end
end
