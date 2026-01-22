require 'fog/kubevirt/compute/models/vm_parser'

module Fog
  module Kubevirt
    class Compute
      module VmBase
        include VmParser

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
          attribute :interfaces,       :aliases => 'spec_interfaces'
          attribute :networks,         :aliases => 'spec_networks'
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
          networks = parse_networks(spec[:networks])
          vm = {
            :namespace        => metadata[:namespace],
            :name             => metadata[:name],
            :resource_version => metadata[:resourceVersion],
            :uid              => metadata[:uid],
            :labels           => metadata[:labels],
            :disks            => disks,
            :volumes          => parse_volumes(spec[:volumes], disks),
            :status           => parse_status(object, :printableStatus),
            :interfaces       => parse_interfaces(domain[:devices][:interfaces], object[:status].nil? ? [] : object[:status][:interfaces], networks),
            :networks         => networks,
            :machine_type     => domain.dig(:machine, :type)
          }
          vm[:owner_reference] = owner unless owner.nil?
          vm[:annotations] = annotations unless annotations.nil?
          vm[:cpu_cores] = cpu[:cores] unless cpu.nil?
          vm[:memory] = mem unless mem.nil?

          vm
        end
      end
    end
  end
end
