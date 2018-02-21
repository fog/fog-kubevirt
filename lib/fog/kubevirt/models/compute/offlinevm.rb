require 'fog/compute/models/server'

module Fog
  module Compute
    class Kubevirt
      class Offlinevm < Fog::Model
        identity :name

        attribute :namespace,       :aliases => 'metadata_namespace'
        attribute :resourceVersion, :aliases => 'metadata_resourceVersion'
        attribute :uid,             :aliases => 'metadata_uid'
        attribute :cpu_cores,       :aliases => 'spec_cpu_cores'
        attribute :memory,          :aliases => 'spec_memory'
        attribute :disks,           :aliases => 'spec_disks'
        attribute :volumes,         :aliases => 'spec_volumes'


        def start(options = {})
        end

        def stop(options = {})
        end

        def self.parse(object)
          metadata = object[:metadata]
          spec = object[:spec][:template][:spec]
          domain = spec[:domain]
          {
            :namespace       => metadata[:namespace],
            :name            => metadata[:name],
            :resourceVersion => metadata[:resourceVersion],
            :uid             => metadata[:uid],
            :cpu_cores       => domain[:cpu][:cores],
            :memory          => domain[:resources][:requests][:memory],
            :disks           => domain[:devices][:disks],
            :volumes         => spec[:volumes]
          }
        end
      end
    end
  end
end
