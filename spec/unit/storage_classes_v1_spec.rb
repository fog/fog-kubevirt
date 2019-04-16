require_relative './spec_helper'
 require_relative './shared_context'

  require 'fog/kubevirt'

  describe Fog::Kubevirt::Compute do
   before :all do
     vcr = KubevirtVCR.new(
       vcr_directory: 'spec/fixtures/kubevirt/storageclass',
       service_class: Fog::Kubevirt::Compute
     )
     @service = vcr.service
   end

    it 'CRUD services' do
     VCR.use_cassette('storageclasses_crud') do
       begin
         name = 'my-storage-class'
         parameters = {
           'resturl'         => 'http://heketi-storage.glusterfs.svc:8080',
           'restuser'        => 'admin',
           'secretName'      => 'heketi-storage-admin-secret',
           'secretNamespace' => 'glusterfs'
         }

         provisioner = 'kubernetes.io/glusterfs'
         reclaim_policy = 'Delete'
         volume_binding_mode = 'Immediate'

         @service.storageclasses.create(name: name,
                              parameters: parameters,
                              provisioner: provisioner,
                              reclaim_policy: reclaim_policy,
                              volume_binding_mode: volume_binding_mode)

          storageclass = @service.storageclasses.get(name)
          assert_equal(storageclass.name, 'my-storage-class')
          assert_equal(storageclass.provisioner, 'kubernetes.io/glusterfs')
          assert_equal(storageclass.reclaim_policy, 'Delete')
          assert_equal(storageclass.volume_binding_mode, 'Immediate')
       ensure
         @service.storageclasses.delete(name) if storageclass
       end
     end
   end
 end
