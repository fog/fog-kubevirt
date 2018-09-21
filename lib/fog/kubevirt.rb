require 'fog/core'

module Fog
  module Compute
    autoload :Kubevirt, File.expand_path('../compute/kubevirt', __FILE__)
  end

  module Kubevirt
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
