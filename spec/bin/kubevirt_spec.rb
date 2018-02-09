require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Kubevirt do
  include Fog::BinSpec

  let(:subject) { Kubevirt }
end
