module Fog
  module Compute
    class Kubevirt
      class Real
        def get_server(name)
          vm = get_raw_vm(name)
          populate_runtime_info(vm)
          Server.parse vm
        end

        # Updates a given VM raw entity with vm instance info if exists
        #
        # @param vm [Hash] A hash with vm raw data.
        def populate_runtime_info(vm)
          vmi = get_vminstance(vm[:metadata][:name])
          vm[:ip_address] = vmi[:ip_address]
          vm[:node_name] = vmi[:node_name]
          vm[:phase] = vmi[:status]
          vm
        rescue
          # do nothing if vmi doesn't exist
        end
      end

      class Mock
        # TODO provide implementation
        def get_server(name)
        end
      end
    end
  end
end
