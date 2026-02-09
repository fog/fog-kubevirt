require_relative './spec_helper'
require_relative './shared_context'

require 'fog/kubevirt'

describe Fog::Compute do
  before :all do
    vcr = KubevirtVCR.new(
      vcr_directory: 'spec/fixtures/kubevirt/server',
      :service_class => Fog::Kubevirt::Compute
    )
    @service = vcr.service
  end

  it 'get server from instance type' do
    VCR.use_cassette('get_server_from_instance_type') do
      server = @service.get_server('ls-test')

      assert(server)
      assert_equal(server[:memory], '4Gi')
      assert_equal(server[:cpu_cores], 1)
    end
  end

  it 'get server created via template' do
    VCR.use_cassette('get_server_from_template') do
      server = @service.get_server('ls-vm-from-template')

      assert(server)
      assert_equal(server[:memory], '2Gi')
      assert_equal(server[:cpu_cores], 1)
    end
  end
end
