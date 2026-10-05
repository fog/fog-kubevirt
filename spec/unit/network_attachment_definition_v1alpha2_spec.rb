require_relative './spec_helper'
require_relative './shared_context'

require 'fog/kubevirt/compute/compute'

describe Fog::Kubevirt::Compute do
  before :all do
    vcr = KubevirtVCR.new(
      vcr_directory: 'spec/fixtures/kubevirt/networkattachmentdefinition',
      service_class: Fog::Kubevirt::Compute
    )
    @service = vcr.service
  end

  it 'CRUD services' do
    VCR.use_cassette('networkattachmentdefinitions_crud') do
      begin
        name = 'ovs-red'
        config = '{ cni_version: "0.3.1", type: "ovs", bridge: "red" }'
        @service.networkattachmentdefs.create(name: name, config: config)

        net_att_def = @service.networkattachmentdefs.get(name)
      ensure
        @service.networkattachmentdefs.delete(name) if net_att_def
      end
    end
  end

  it 'lists services in the configured namespace' do
    VCR.use_cassette('networkattachmentdefinitions_crud') do
      net_att_defs = @service.networkattachmentdefs.all

      assert_equal(1, net_att_defs.count)
      assert_equal('default', net_att_defs.first.namespace)
    end
  end
end
