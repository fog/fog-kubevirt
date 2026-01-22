require_relative './spec_helper'

describe Fog::Kubevirt::Compute do
  it 'parses vm' do
    Fog.mock!
    mock = Fog::Kubevirt::Compute.new
    vm = mock.get_vm('test')

    assert_nil(vm[:interfaces][0].mac_address)
    assert_nil(vm[:interfaces][1].mac_address)
    Fog.unmock!
  end

  it 'parses vmi' do
    Fog.mock!
    mock = Fog::Kubevirt::Compute.new
    vm = mock.get_vminstance('test')

    assert_equal(vm[:interfaces][0].mac_address, '0e:fc:6c:c3:20:ec')
    assert_equal(vm[:interfaces][1].mac_address, '4a:90:1c:2e:fe:d7')
    Fog.unmock!
  end

  it 'parses not ready server' do
    Fog.mock!
    mock = Fog::Kubevirt::Compute.new
    server = mock.get_server('no_interfaces')

    assert_nil(server[:interfaces])
    Fog.unmock!
  end

  it 'parses vm interface of pod network' do
    Fog.mock!
    mock = Fog::Kubevirt::Compute.new
    vm = mock.get_vm('robin-rykert.example.com')

    assert_nil(vm[:interfaces][0].network)
    assert_equal(vm[:interfaces][0].cni_provider, "pod")

    assert_equal(vm[:interfaces][1].network, "ptp-conf")
    assert_equal(vm[:interfaces][1].cni_provider, "multus")
    Fog.unmock!
  end

  it 'parses vm status' do
    Fog.mock!
    mock = Fog::Kubevirt::Compute.new
    vm = mock.get_vm('test')

    assert_equal(vm[:status], "running")
    Fog.unmock!
  end

  it 'parses vmi status' do
    Fog.mock!
    mock = Fog::Kubevirt::Compute.new
    vmi = mock.get_vminstance('test')

    # phase value is used for the status in vminstance.rb, not printableStatus
    assert_equal(vmi[:status], "running")
    Fog.unmock!
  end
end
