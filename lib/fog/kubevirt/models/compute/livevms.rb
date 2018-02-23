require 'fog/core/collection'
require 'fog/kubevirt/models/compute/livevm'

module Fog
  module Compute
    class Kubevirt
      class Livevms < Fog::Collection
        model Fog::Compute::Kubevirt::Livevm

        def all(filters = {})
          load service.list_livevms(filters)
        end

        def get(name)
          new service.get_livevm(name)
        end
      end
    end
  end
end