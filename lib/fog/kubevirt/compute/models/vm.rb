require 'fog/kubevirt/compute/models/vm_base'
require 'fog/kubevirt/compute/models/vm_action'

module Fog
  module Kubevirt
    class Compute
      class Vm < Fog::Model
        include VmAction
        extend VmBase
        define_properties

        def self.parse(object)
          parse_object(object)
        end
      end
    end
  end
end
