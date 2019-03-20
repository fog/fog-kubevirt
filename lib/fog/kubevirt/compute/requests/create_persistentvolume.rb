module Fog
  module Kubevirt
    class Compute
      class Real
        def create_persistentvolume(volume)
          kube_client.create_persistent_volume(volume)
        rescue ::Fog::Kubevirt::Errors::ClientError => err
          log.warn(err)
          raise ::Fog::Kubevirt::Errors::AlreadyExistsError
        end
      end

      class Mock
        def create_persistentvolume(volume)
        end
      end
    end
  end
end