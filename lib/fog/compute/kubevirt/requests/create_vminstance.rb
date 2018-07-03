module Fog
  module Compute
    class Kubevirt
      class Real

        def create_vminstance(vm)
          kubevirt_client.create_virtual_machine_instance(vm)
        rescue ::Fog::Kubevirt::Errors::ClientError => err
          log.warn(err)
          raise ::Fog::Kubevirt::Errors::AlreadyExistsError
        end
      end

      class Mock
        def create_vminstance(vm)
        end
      end
    end
  end
end
