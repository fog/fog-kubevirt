require_relative './spec_helper'
require 'fog/kubevirt/compute/compute'

describe Fog::Kubevirt::Compute do
  describe 'secrets API' do
    it 'exposes secrets collection and get_secret on mock' do
      Fog.mock!
      mock = Fog::Kubevirt::Compute.new(kubevirt_namespace: 'default')

      # Mock list_secrets returns nil; only test get (mock get_secret returns {})
      secret = mock.secrets.get('some-secret')
      assert secret
      assert_nil secret.name

      Fog.unmock!
    end
  end
end
