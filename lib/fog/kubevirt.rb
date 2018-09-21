require 'fog/core'

module Fog
  module Kubevirt
    autoload :Compute, 'fog/kubevirt/compute/compute'
    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error; end
      class AlreadyExistsError < Fog::Errors::Error; end
      class ClientError < Fog::Errors::Error; end
      class ValidationError < Fog::Errors::Error; end
    end

    service(:compute, 'Compute')
  end
end
