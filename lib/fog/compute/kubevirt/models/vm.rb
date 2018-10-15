require 'fog/compute/kubevirt/models/vm_base'

module Fog
  module Compute
    class Kubevirt
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
