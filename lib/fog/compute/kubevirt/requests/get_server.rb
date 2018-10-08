module Fog
  module Compute
    class Kubevirt
      class Real
        def get_server(name)
          vm = get_raw_vm(name)
          populate_server_with_runtime_info(vm)
          Server.parse vm
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
