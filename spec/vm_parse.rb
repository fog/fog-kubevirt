describe Fog::Kubevirt::Compute do
  it 'parses vm' do
    mock = Fog::Kubevirt::Compute::Mock.new
    vm = mock.get_vm('test')

    assert_nil(vm[:interfaces][0].mac_address)
    assert_nil(vm[:interfaces][1].mac_address)
  end

  it 'parses vmi' do
    mock = Fog::Kubevirt::Compute::Mock.new
    vm = mock.get_vminstance('test')

    assert_equal(vm[:interfaces][0].mac_address, '0e:fc:6c:c3:20:ec')
    assert_equal(vm[:interfaces][1].mac_address, '4a:90:1c:2e:fe:d7')
  end
end