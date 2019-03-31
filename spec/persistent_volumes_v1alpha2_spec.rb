require 'spec_helper'
 require_relative './shared_context'

  require 'fog/kubevirt'

  describe Fog::Kubevirt::Compute do
   before :all do
     vcr = KubevirtVCR.new(
       vcr_directory: 'spec/fixtures/kubevirt/persistentvolume',
       service_class: Fog::Kubevirt::Compute
     )
     @service = vcr.service
   end

    it 'CRUD services' do
     VCR.use_cassette('persistent_volumes_crud') do
       begin
         name = 'my-local-storage'
         access_modes = [ 'ReadWriteOnce' ]
         capacity = '1Gi'
         labels = { type: 'local' }
         storage_class = 'manual'
         type = 'hostPath'
         config = { path: "/mnt/data/datax", type: "Directory" }

         @service.persistentvolumes.create(name: name,
                                           access_modes: access_modes,
                                           capacity: capacity,
                                           labels: labels,
                                           storage_class: storage_class,
                                           type: type,
                                           config: config)

          volume = @service.persistentvolumes.get(name)
          assert_equal(volume.name, 'my-local-storage')
          assert_equal(volume.access_modes, [ 'ReadWriteOnce' ])
          assert_equal(volume.capacity, '1Gi')
          assert_equal(volume.storage_class, 'manual')
          assert_equal(volume.type, 'hostPath')
       ensure
         @service.persistentvolumes.delete(name) if volume
       end
     end
   end
 end