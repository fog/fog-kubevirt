require 'spec_helper'
require_relative './shared_context'

require 'fog/kubevirt'

describe Fog::Compute do
  before :all do
    vcr = KubevirtVCR.new(
      :vcr_directory => 'spec/fixtures/kubevirt/service',
      :service_class => Fog::Compute
    )
    @service = vcr.service
  end

  it 'CRUD services' do
	VCR.use_cassette('services_crud') do
      begin
        port = 30000
        vmi_name = "vmi-fedora"
        srv_name = "#{vmi_name}-ssh"
        srv_type = "NodePort"
        @service.services.create(port: port, name: srv_name, target_port: 22, vmi_name: vmi_name, service_type: srv_type)

        srv = @service.services.get(srv_name)
      ensure
        @service.services.delete(srv_name) if srv
      end
    end
  end
end