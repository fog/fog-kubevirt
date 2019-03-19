module Fog
  module Compute
    class Kubevirt
      class Real
        def create_storageclass(storageclass)
          kube_storage_client.create_storage_class(storageclass)
        rescue ::Fog::Kubevirt::Errors::ClientError => err
          log.warn(err)
          raise ::Fog::Kubevirt::Errors::AlreadyExistsError
        end
      end

      class Mock
        def create_storage_class(attrs); end
      end
    end
  end
end
