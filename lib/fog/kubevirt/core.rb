module Fog
  module Kubevirt
    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error; end
      class AlreadyExistsError < Fog::Errors::Error; end
    end

    service(:compute, 'Compute')
  end
end
