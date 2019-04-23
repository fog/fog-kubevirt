require_relative './spec_helper'
require_relative './shared_context'

describe Fog::Compute do
  before :all do
    vcr = KubevirtVCR.new(
      vcr_directory: 'spec/fixtures/kubevirt/server',
      :service_class => Fog::Kubevirt::Compute
    )
    @service = vcr.service
  end

  it 'fetches, starts, stops and destroy server' do
    VCR.use_cassette('server_ops') do
      server = @service.servers.get('vm-cirros')
      assert(server)

      server.stop
      server = @service.servers.get('vm-cirros')
      assert(server)

      server.start
      # no validation - this operation takes too long

      server.destroy
      begin
        server = @service.servers.get('vm-cirros')
        fail "server should not exist"
      rescue Fog::Kubevirt::Errors::ClientError
        # expected
      end 
    end
  end
end