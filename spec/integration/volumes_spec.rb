require_relative './shared_context'

require 'fileutils'

describe Fog::Kubevirt::Compute do
  before :all do
    conn = KubevirtConnection.new()
    @client = conn.client
  end

  it 'creates volumes' do
    scs = @client.storageclasses.all()
    default_sc = scs.find { | sc | sc.default }

    dir = Dir.mktmpdir

    name = 'my-local-storage'
    access_modes = [ 'ReadWriteOnce' ]
    capacity = '1Gi'
    type = 'hostPath'
    config = { path: dir, type: "Directory" }

    @client.persistentvolumes.create(name: name,
                                     access_modes: access_modes,
                                     capacity: capacity,
                                     storage_class: default_sc.name,
                                     type: type,
                                     config: config)

    pv = @client.persistentvolumes.get(name)
    assert_equal(pv.storage_class, default_sc.name)
    assert_equal(pv.capacity, capacity)
    assert_equal(pv.access_modes, access_modes)

    @client.persistentvolumes.delete(name)
    FileUtils.remove_entry dir

    begin
      @client.persistentvolumes.get(name)
      fail "pv should not exist"
    rescue ::Fog::Kubevirt::Errors::ClientError
      # expected
    end    
  end
end