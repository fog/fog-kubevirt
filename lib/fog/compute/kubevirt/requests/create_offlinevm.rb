module Fog
  module Compute
    class Kubevirt
      class Real
        def create_offlinevm(vm)
          kubevirt_client.create_offline_virtual_machine(vm)
        rescue KubeException
          raise ::Fog::Kubevirt::Errors::AlreadyExistsError
        end
      end

      class Mock
        def create_offlinevm(vm); end
      end
    end
  end
end
