require_relative './shared_context'

describe Fog::Kubevirt::Compute do
  before :all do
    conn = KubevirtConnection.new()
    @client = conn.client
    @watch = nil
  end

  it 'creates VMI and checks MAC' do
    vm_name = 'test'
    cpus = 1
    memory_size = 64

    volume = Fog::Kubevirt::Compute::Volume.new
    volume.type = 'containerDisk'
    volume.name = 'test-disk-01'
    volume.info = 'registry:5000/kubevirt/cirros-container-disk-demo:devel'

    @client.vms.create(vm_name: vm_name, cpus: cpus, memory_size: memory_size, volumes: [volume])

    vm = @client.vms.get(vm_name)
    assert_equal(vm.cpu_cores, cpus)
    assert_equal(vm.memory, "#{memory_size}M")

    vm.start()

    # check whether vmi to be created if not it will raise ClientError
    @client.vminstances.get(vm_name)

    vmis = @client.vminstances.all()
    @watch = @client.watch_vminstances(:resource_version => vmis.resource_version)

    thread = Thread.new do
      @watch.each do |notice|
        break if notice.type == 'MODIFIED' && notice.status == 'Running'
      end
    end

    if thread.join(60).nil?
      fail('VMI did not start')
    end
    @watch.finish
    @watch = nil

    vmi = @client.vminstances.get(vm_name)

    assert_equal(vm.cpu_cores, cpus)
    assert_equal(vm.memory, "#{memory_size}M")

    vmi.interfaces do |iface|
      assert !iface.mac_address.nil?
    end

    vmis = @client.vminstances.all()
    @watch = @client.watch_vminstances(:resource_version => vmis.resource_version)

    @client.vminstances.destroy(vm_name, 'default')

    thread = Thread.new do
      @watch.each do |notice|
        break if notice.type == 'DELETED'
      end
    end

    if thread.join(60).nil?
      fail('VMI was not removed')
    end
    @watch.finish
    @watch = nil
  end

  it 'creates VMI and checks MAC using server' do
    vm_name = 'test-server'
    cpus = 1
    memory_size = 64

    volume = Fog::Kubevirt::Compute::Volume.new
    volume.type = 'containerDisk'
    volume.name = 'test.disk.01'
    volume.info = 'registry:5000/kubevirt/cirros-container-disk-demo:devel'

    @client.vms.create(vm_name: vm_name, cpus: cpus, memory_size: memory_size, volumes: [volume])

    server_vm = @client.servers.get(vm_name)
    assert_equal(server_vm.cpu_cores, cpus)
    assert_equal(server_vm.memory, "#{memory_size}M")

    server_vm.start()

    # check whether vmi to be created if not it will raise ClientError
    @client.servers.get(vm_name)

    vmis = @client.vminstances.all()
    @watch = @client.watch_vminstances(:resource_version => vmis.resource_version)

    thread = Thread.new do
      @watch.each do |notice|
        break if notice.type == 'MODIFIED' && notice.status == 'Running'
      end
    end

    if thread.join(60).nil?
      fail('Server did not start')
    end
    @watch.finish
    @watch = nil

    server = @client.servers.get(vm_name)

    assert_equal(server.cpu_cores, cpus)
    assert_equal(server.memory, "#{memory_size}M")

    server.interfaces do |iface|
      assert !iface.mac_address.nil?
    end

    vmis = @client.vminstances.all()
    @watch = @client.watch_vminstances(:resource_version => vmis.resource_version)

    server.destroy

    thread = Thread.new do
        @watch.each do |notice|
          break if notice.type == 'DELETED'
        end
      end
  
      if thread.join(60).nil?
        fail('Server was not removed')
      end
      @watch.finish
      @watch = nil
  end
end