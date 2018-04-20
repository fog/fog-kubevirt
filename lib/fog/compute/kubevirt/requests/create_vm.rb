module Fog
  module Compute
    class Kubevirt
      class Real
        def create_vm(vm)
          kubevirt_client.create_virtual_machine(vm)
        rescue Kubeclient::HttpError
          log.warn(err)
          raise ::Fog::Kubevirt::Errors::AlreadyExistsError
        end
      end

      class Mock
        def create_vm(vm)
        end
      end
    end
  end
end
