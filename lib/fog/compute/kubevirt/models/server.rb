require 'fog/compute/models/server'
require 'fog/compute/kubevirt/models/vm_base'

module Fog
  module Compute
    class Kubevirt
      class Server < Fog::Compute::Server
        include Shared
        include VmAction
        extend VmBase
        define_properties

        attribute :state, :aliases => 'phase'
        attribute :ip_address
        attribute :node_name

        def destroy(options = {})
          stop(options)
          service.delete_vm(name, namespace)
        end

        def ready?
          running?(status) && running?(state) && !ip_address.empty?
        end

        def self.parse(object)
          server = parse_object(object)
          server[:status] = object[:phase]
          server[:node_name] = object[:node_name]
          server[:ip_address] = object[:ip_address]
          server
        end

        private

        def running?(status)
          !status.nil? && 'running'.casecmp(status).zero?
        end
      end
    end
  end
end
