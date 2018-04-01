module Fog
  module Compute
    class Kubevirt
      class Livevm < Fog::Model
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

        def self.parse(object)
          metadata = object[:metadata]
          owner = metadata[:ownerReferences][0]
          spec = object[:spec]
          domain = spec[:domain]
          {
            :namespace        => metadata[:namespace],
            :name             => metadata[:name],
            :resource_version => metadata[:resourceVersion],
            :uid              => metadata[:uid],
            :owner_name       => owner[:name],
            :owner_uid        => owner[:uid],
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