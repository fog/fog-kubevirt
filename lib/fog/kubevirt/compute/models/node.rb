module Fog
  module Kubevirt
    class Compute
      class Node < Fog::Model
        identity :name

        attribute :namespace,        :aliases => 'metadata_namespace'
        attribute :resource_version, :aliases => 'metadata_resource_version'
        attribute :uid,              :aliases => 'metadata_uid'
        attribute :os_image,         :aliases => 'status_node_info_os_image'
        attribute :operating_system, :aliases => 'status_node_info_operating_system'
        attribute :kernel_version,   :aliases => 'status_node_info_kernel_version'
        attribute :hostname,         :aliases => 'status_addresses_hostname'
        attribute :ip_address,       :aliases => 'status_addresses_ip'

        def self.parse(object)
          metadata = object[:metadata]
          status = object[:status]
          info = status[:nodeInfo]

          addresses = status[:addresses]
          hostname = addresses.detect { |address| address[:type] == 'Hostname' }[:address]
          ip = addresses.detect { |address| address[:type] == 'InternalIP' }[:address]
          {
            :namespace        => metadata[:namespace],
            :name             => metadata[:name],
            :resource_version => metadata[:resourceVersion],
            :uid              => metadata[:uid],
            :os_image         => info[:osImage],
            :operating_system => info[:operatingSystem],
            :kernel_version   => info[:kernelVersion],
            :hostname         => hostname,
            :ip_address       => ip
          }
        end
      end
    end
  end
end
