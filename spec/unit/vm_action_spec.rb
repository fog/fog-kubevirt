require_relative './spec_helper'

describe 'VmAction' do
  before { Fog.mock! }
  after { Fog.unmock! }

  describe 'legacy VM (running field)' do
    it 'start and stop changes running state' do
      service = Fog::Kubevirt::Compute.new

      vm_state = service.get_raw_vm('test')
      service.define_singleton_method(:get_raw_vm) { |n| vm_state }
      service.define_singleton_method(:update_vm) { |v| vm_state.replace(v) }

      vm = service.vms.get('test')

      vm.start
      assert_equal true, vm_state[:spec][:running]

      vm.stop
      assert_equal false, vm_state[:spec][:running]
    end
  end

  describe 'modern VM (runStrategy field)' do
    it 'start and stop changes runStrategy state' do
      service = Fog::Kubevirt::Compute.new

      vm_state = service.get_raw_vm('test')
      vm_state[:spec].delete(:running)
      vm_state[:spec][:runStrategy] = 'Halted'
      service.define_singleton_method(:get_raw_vm) { |n| vm_state }
      service.define_singleton_method(:update_vm) { |v| vm_state.replace(v) }

      vm = service.vms.get('test')

      vm.start
      assert_equal 'Always', vm_state[:spec][:runStrategy]

      vm.stop
      assert_equal 'Halted', vm_state[:spec][:runStrategy]
    end
  end
end
