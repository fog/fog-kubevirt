require 'spec_helper'
require_relative './shared_context'

require 'fog/kubevirt'

describe Fog::Compute do
  before :all do
    vcr = KubevirtVCR.new(
      vcr_directory: 'spec/fixtures/kubevirt/networkattachmentdefinition/v1alpha2',
      service_class: Fog::Compute
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
end
