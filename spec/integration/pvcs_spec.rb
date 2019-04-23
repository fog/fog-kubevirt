require_relative './shared_context'

describe Fog::Kubevirt::Compute do
  before :all do
    conn = KubevirtConnection.new()
    @client = conn.client.pvcs
  end

  it 'CRD pvc' do
    pvc = {
      :name => 'test-pvc',
      :namespace => 'default',
      :storage_class => '',
      :access_modes => ['ReadWriteOnce'],
      :requests => { storage: "1Gi" }
    }
    @client.create(pvc)

    created = @client.get(pvc[:name])
    assert_equal(created.name, pvc[:name])
    assert_equal(created.requests, pvc[:requests])

    @client.delete(pvc[:name])

    begin
      @client.get('no_pvc')
      fail "pvc should not exist"
    rescue ::Fog::Kubevirt::Errors::ClientError
      # expected
    end
  end

  it 'deletes non-existing pvc' do
    begin
      @client.delete('not_there')
    rescue ::Fog::Kubevirt::Errors::ClientError
      # it ignores non-existing object
      fail "pvc should not exist"
    end
  end

  it 'fails with wrong size format' do
    pvc = {
      :name => 'test-pvc',
      :namespace => 'default',
      :storage_class => '',
      :access_modes => ['ReadWriteOnce'],
      :requests => { storage: "X" }
    }
    begin
      @client.create(pvc)
      fail "requested size is not correct"
    rescue ::Fog::Kubevirt::Errors::ValidationError
      # expected
    end
  end
end