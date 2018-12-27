require 'spec_helper'
 require_relative './shared_context'

  require 'fog/kubevirt'

  describe Fog::Compute do
   before :all do
     vcr = KubevirtVCR.new(
       vcr_directory: 'spec/fixtures/kubevirt/pvc/v1alpha2',
       service_class: Fog::Compute
     )
     @service = vcr.service
   end

    it 'CRUD services' do
     VCR.use_cassette('pvcs_crud') do
       begin
         name = 'my-local-storage-pvc'
         namespace = 'default'
         access_modes = [ 'ReadWriteOnce' ]
         volume_name = 'my-local-storage'
         volume_mode = 'Filesystem'
         match_labels = {}
         match_expressions = []
         storage_class = 'manual'
         requests = { storage: "2Gi" }
         limits = { storage: "3Gi" }

         @service.pvcs.create(name: name,
                              namespace: namespace,
                              access_modes: access_modes,
                              volume_name: volume_name,
                              volume_mode: volume_mode,
                              match_labels: match_labels,
                              match_expressions: match_expressions,
                              storage_class: storage_class,
                              limits: limits,
                              requests: requests)

          pvc = @service.pvcs.get(name)
          assert_equal(pvc.name, 'my-local-storage-pvc')
          assert_equal(pvc.access_modes, [ 'ReadWriteOnce' ])
          assert_equal(pvc.storage_class, 'manual')
          assert_equal(pvc.volume_name, 'my-local-storage')
          assert_equal(pvc.requests[:storage], '2Gi')
          assert_equal(pvc.limits[:storage], '3Gi')
       ensure
         @service.pvcs.delete(name) if pvc
       end
     end
   end
 end
