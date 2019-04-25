require_relative './shared_context'

describe Fog::Kubevirt::Compute do
  before :all do
    conn = KubevirtConnection.new()
    @client = conn.client.networkattachmentdefs
  end

  it 'CRD network attachements' do
    name = 'ovs-red'
    config = '{ cni_version: "0.3.1", type: "ovs", bridge: "red" }'

    @client.create(name: name, config: config)

    net_att_def = @client.get(name)
    assert_equal(net_att_def.config, config)

    @client.delete(name)

    begin
      @client.get(name)
      fail "net_attach_def should not exist"
    rescue ::Fog::Kubevirt::Errors::ClientError
      # expected
    end
  end

  it 'creates empty config' do
    begin
      @client.create(name: 'aaa')
      fail "empty config can not be nil"
    rescue ::Fog::Kubevirt::Errors::AlreadyExistsError
      # expected
    end

    begin
      @client.create(name: 'aaa', config: '{}')
      fail "empty config can not be nil"
    rescue ::Fog::Kubevirt::Errors::AlreadyExistsError
      # expected
    end  
  end
end