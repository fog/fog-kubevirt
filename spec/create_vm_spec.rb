require 'spec_helper'
require_relative './shared_context'

require 'fog/kubevirt'
require 'fog/kubevirt/compute/models/volume'

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
        pvc1 = 'mypvc1'
        pvc2 = 'mypvc2'

        # PVCs should already be created
        volume1 = Fog::Kubevirt::Compute::Volume.new
        volume1.type = 'persistentVolumeClaim'
        volume1.name = 'test-disk-01'
        volume1.boot_order = 1
        volume1.bus = 'virtio'
        volume1.info = pvc1

        volume2 = Fog::Kubevirt::Compute::Volume.new
        volume2.type = 'persistentVolumeClaim'
        volume2.name = 'test-disk-02'
        volume2.boot_order = 2
        volume2.bus = 'virtio'
        volume2.info = pvc2

        volume3 = Fog::Kubevirt::Compute::Volume.new
        volume3.type = 'hostDisk'
        volume3.name = 'test-disk-03'
        volume3.boot_order = 3
        volume3.config = {
          :capacity => '1Gi',
          :path     => '/mnt/data/disk.img',
          :type     => 'DiskOrCreate'
        }

        create_pvc(@service, pvc1)
        create_pvc(@service, pvc2)
        @service.vms.create(vm_name: vm_name, cpus: cpus, memory_size: memory_size, volumes: [volume1, volume2, volume3])

        vm = @service.vms.get(vm_name)

        # test vm volumes
        volumes = @service.volumes.all vm_name
        assert_equal(volumes.count, 3)

        # verify first claim values
        volume = volumes.select { |v| v.name == 'test-disk-01' }.first
        refute_nil(volume)
        refute_nil(volume.pvc)
        assert_equal(volume.name, 'test-disk-01')
        assert_equal(volume.pvc.name, pvc1)
        assert_equal(volume.type, 'persistentVolumeClaim')

        # verify second claim values
        volume = volumes.select { |v| v.name == 'test-disk-02' }.first
        refute_nil(volume)
        refute_nil(volume.pvc)
        assert_equal(volume.pvc.name, pvc2)
        assert_equal(volume.name, 'test-disk-02')
        assert_equal(volume.type, 'persistentVolumeClaim')

        # verify third claim values
        volume = volumes.select { |v| v.name == 'test-disk-03' }.first
        refute_nil(volume)
        assert_equal(volume.name, 'test-disk-03')
        assert_equal(volume.type, 'hostDisk')
      ensure
        @service.vms.delete(vm_name) if vm
        @service.pvcs.delete(pvc1)
        @service.pvcs.delete(pvc2)
      end
    end
  end

  def create_pvc(service, name)
     namespace = 'default'
     access_modes = [ 'ReadWriteOnce' ]
     storage_class = 'local-storage'
     requests = { storage: "1Gi" }

     service.pvcs.create(name: name,
                          namespace: namespace,
                          access_modes: access_modes,
                          storage_class: storage_class,
                          requests: requests)
  end

  it 'creates vm with single pvc' do
    VCR.use_cassette("vm_create_single") do
      begin
        vm_name = 'test2'
        cpus = 1
        memory_size = 64

        volume = Fog::Kubevirt::Compute::Volume.new
        volume.type = 'persistentVolumeClaim'
        volume.info = 'mypvc3'
        @service.vms.create(vm_name: vm_name, cpus: cpus, memory_size: memory_size, volumes: [volume])

        vm = @service.vms.get(vm_name)

        # test vm volumes
        volumes = @service.volumes.all vm_name
        assert_equal(volumes.count, 1)

        # verify third claim values
        volume = volumes.first
        refute_nil(volume)
        assert_equal(volume.name, 'test2-disk-00')
        assert_equal(volume.type, 'persistentVolumeClaim')
      ensure
        @service.vms.delete(vm_name) if vm
      end
    end
  end
end