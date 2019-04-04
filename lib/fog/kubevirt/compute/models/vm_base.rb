require 'fog/kubevirt/compute/models/vm_data'

module Fog
  module Kubevirt
    class Compute
      module VmBase
        include VmData

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
          attribute :disks,            :aliases => 'spec_disks',               :default => []
          attribute :volumes,          :aliases => 'spec_volumes',             :default => []
          attribute :status,           :aliases => 'spec_running'
          attribute :interfaces,       :aliases => 'spec_interfaces',          :default => []
          attribute :networks,         :aliases => 'spec_networks',            :default => []
          attribute :machine_type,     :aliases => 'spec_machine_type'
        end

        def parse_object(object)
          metadata = object[:metadata]
          spec = object[:spec][:template][:spec]
          domain = spec[:domain]
          owner = metadata[:ownerReferences]
          annotations = metadata[:annotations]
          cpu = domain[:cpu]
          mem = domain.dig(:resources, :requests, :memory)
          disks = parse_disks(domain[:devices][:disks])
          vm = {
            :namespace        => metadata[:namespace],
            :name             => metadata[:name],
            :resource_version => metadata[:resourceVersion],
            :uid              => metadata[:uid],
            :labels           => metadata[:labels],
            :disks            => disks,
            :volumes          => parse_volumes(spec[:volumes], disks),
            :status           => object[:spec][:running].to_s == "true" ? "running" : "stopped",
            :interfaces       => parse_interfaces(domain[:devices][:interfaces]),
            :networks         => parse_networks(spec[:networks]),
            :machine_type     => domain.dig(:machine, :type)
          }
          vm[:owner_reference] = owner unless owner.nil?
          vm[:annotations] = annotations unless annotations.nil?
          vm[:cpu_cores] = cpu[:cores] unless cpu.nil?
          vm[:memory] = mem unless mem.nil?

          vm
        end
      end

      module VmAction
        include Shared

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
