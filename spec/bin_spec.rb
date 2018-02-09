require "spec_helper"
require "fog/bin"

describe Fog do
  describe "#providers" do
    it "includes existing providers" do
      assert_equal "Kubevirt", Fog.providers[:kubevirt]
    end
  end

  describe "#registered_providers" do
    it "includes existing providers" do
      assert_includes Fog.registered_providers, "Kubevirt"
    end
  end

  describe "#available_providers" do
    it "includes existing providers" do
      assert_includes Fog.available_providers, "Kubevirt" if Kubevirt.available?
    end
  end

  describe "#services" do
    it "returns Hash of services" do
      assert_kind_of Hash, Fog.services
    end
  end
end
