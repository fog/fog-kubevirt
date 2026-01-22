require 'fog/compute/models/server'
require 'fog/kubevirt/compute/models/vm_base'
require 'fog/kubevirt/compute/models/vm_action'

module Fog
  module Kubevirt
    class Compute
      class Server < Fog::Compute::Server
        include Shared
        include VmAction
        extend VmBase
        define_properties

        attribute :phase
        attribute :ip_address
        attribute :node_name

        def destroy(options = {})
          stop(options)
          service.delete_vm(name, namespace)
        end

        # TODO: Once IP Addresses are reported to any networks, we should consider also
        # the availabity of it (by extending the condition with !ip_address.empty?)
        def ready?
          running?(status) && running?(phase)
        end

        def self.parse(object)
          server = parse_object(object)
          server[:phase] = parse_status(object, :phase)
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
