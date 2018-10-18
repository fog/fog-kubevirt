module Fog
  module Compute
    class Kubevirt
      class Service < Fog::Model
        identity :name

        attribute :namespace,        :aliases => 'metadata_namespace'
        attribute :resource_version, :aliases => 'metadata_resource_version'
        attribute :cluster_ip,       :aliases => 'spec_cluster_ip'
        attribute :node_port,        :aliases => 'spec_ports_node_port'
        attribute :port,             :aliases => 'spec_ports_port'
        attribute :target_port,      :aliases => 'spec_ports_target_port'
        attribute :selector,         :aliases => 'spec_selector'

        def self.parse(object)
          metadata = object[:metadata]
          spec = object[:spec]
          ports = spec[:ports][0]
          selector = spec[:selector]
          srv = {
            :namespace        => metadata[:namespace],
            :name             => metadata[:name],
            :resource_version => metadata[:resourceVersion],
            :cluster_ip       => spec[:clusterIP],
            :node_port        => ports[:nodePort],
            :port             => ports[:port],
            :target_port      => ports[:target_port],
          }
          srv[:selector] = selector[:special] unless selector.nil?

          srv
        end
      end
    end
  end
end