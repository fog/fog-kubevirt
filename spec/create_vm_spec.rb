require 'spec_helper'
require_relative './shared_context'

require 'fog/kubevirt'

describe Fog::Compute do
  before :all do
    vcr = KubevirtVCR.new(
      vcr_directory: 'spec/fixtures/kubevirt/vm',
      :service_class => Fog::Kubevirt::Compute
    )
    @service = vcr.service
  end

  it 'creates vm with multipe pvcs' do
    VCR.use_cassette('vm_create_multi') do
      begin
        vm_name = 'test'
        cpus = 1
        memory_size = 64
        pvcs = ['mypvc1', 'mypvc2']
        @service.vms.create(vm_name: vm_name, cpus: cpus, memory_size: memory_size, pvc: pvcs)

        vm = @service.vms.get(vm_name)
      ensure
        @service.vms.delete(vm_name) if vm
      end
    end
  end

  it 'creates vm with single pvc' do
    VCR.use_cassette("vm_create_single") do
      begin
        vm_name = 'test2'
        cpus = 1
        memory_size = 64
        pvc = 'mypvc3'
        @service.vms.create(vm_name: vm_name, cpus: cpus, memory_size: memory_size, pvc: pvc)

        vm = @service.vms.get(vm_name)
      ensure
        @service.vms.delete(vm_name) if vm
      end
    end
  end
end