require "fog/core"
require "fog/xml"

module Fog
  module Compute
    autoload :Kubevirt, File.expand_path('../kubevirt/compute', __FILE__)
  end

  module Kubevirt
    extend Fog::Provider

    service(:compute, "Compute")
  end
end
