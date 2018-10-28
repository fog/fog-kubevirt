require 'fog/compute/kubevirt/models/vm_data'

module Fog
  module Compute
    class Kubevirt
      class Vminstance < Fog::Model
        extend VmData

        identity :name

        attribute :namespace,        :aliases => 'metadata_namespace'
        attribute :resource_version, :aliases => 'metadata_resource_version'
        attribute :uid,              :aliases => 'metadata_uid'
        attribute :owner_name,       :aliases => 'metadata_owner_name'
        attribute :owner_uid,        :aliases => 'metadata_owner_uid'
        attribute :cpu_cores,        :aliases => 'spec_cpu_cores'
        attribute :memory,           :aliases => 'spec_memory'
        attribute :disks,            :aliases => 'spec_disks'
        attribute :volumes,          :aliases => 'spec_volumes'
        attribute :ip_address,       :aliases => 'status_interfaces_ip'
        attribute :interfaces,       :aliases => 'spec_interfaces'
        attribute :networks,         :aliases => 'spec_networks'
        attribute :node_name,        :aliases => 'status_node_name'
        attribute :status,           :aliases => 'status_phase'

        def self.parse(object)
          metadata = object[:metadata]
          status = object[:status]
          spec = object[:spec]
          domain = spec[:domain]
          {
            :namespace        => metadata[:namespace],
            :name             => metadata[:name],
            :resource_version => metadata[:resourceVersion],
            :uid              => metadata[:uid],
            :owner_name       => metadata.dig(:ownerReferences, 0, :name),
            :owner_uid        => metadata.dig(:ownerReferences, 0, :uid),
            :cpu_cores        => domain.dig(:cpu, :cores),
            :memory           => domain[:resources][:requests][:memory],
            :disks            => parse_disks(domain[:devices][:disks]),
            :volumes          => parse_volumes(spec[:volumes]),
            :interfaces       => parse_interfaces(domain[:devices][:interfaces]),
            :networks         => parse_networks(spec[:networks]),
            :ip_address       => status.dig(:interfaces, 0, :ipAddress),
            :node_name        => status[:nodeName],
            :status           => status[:phase]
          }
        end
      end
    end
  end
end
