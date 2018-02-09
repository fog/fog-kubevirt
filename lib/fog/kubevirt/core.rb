module Fog
  module Kubevirt
    extend Fog::Provider

    module Errors
    end

    service(:compute, 'Compute')
  end
end
