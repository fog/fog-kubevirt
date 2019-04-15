require 'spec_helper'
 require_relative './shared_context'

  require 'fog/kubevirt/compute/compute'

  describe Fog::Kubevirt::Compute do
   before :all do
     vcr = KubevirtVCR.new(
       vcr_directory: 'spec/fixtures/kubevirt/pvc',
       service_class: Fog::Kubevirt::Compute
     )
     @service = vcr.service
   end

    it 'CRUD service without selector' do
     VCR.use_cassette('pvcs_crud') do
       begin
         name = 'my-local-storage-pvc'
         namespace = 'default'
         access_modes = [ 'ReadWriteOnce' ]
         volume_name = 'my-local-storage'
         volume_mode = 'Filesystem'
         match_labels = { component: 'test' }
         match_expressions = [ { key: 'tier', operator: 'In', values: ['dev'] } ]
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
          assert_equal(pvc.match_expressions, [{:key=>"tier", :values=>["dev"], :operator=>"In"}])
          assert_equal(pvc.match_labels, {:component=>"test"})

          # test all volumes based on PVCs
          volumes = @service.volumes.all
          volume = volumes.detect { |v| v.name == name }
          refute_nil(volume)
          assert_equal(volume.name, 'my-local-storage-pvc')
          assert_equal(volume.type, 'persistentVolumeClaim')
       ensure
         @service.pvcs.delete(name) if pvc
       end
     end
    end

    it 'CRUD service without selector' do
     VCR.use_cassette('pvcs_no_selector_crud') do
       begin
         name = 'my-local-storage-pvc'
         namespace = 'default'
         access_modes = [ 'ReadWriteOnce' ]
         volume_name = 'my-local-storage'
         volume_mode = 'Filesystem'
         storage_class = 'manual'
         requests = { storage: "2Gi" }
         limits = { storage: "3Gi" }

         @service.pvcs.create(name: name,
                              namespace: namespace,
                              access_modes: access_modes,
                              volume_name: volume_name,
                              volume_mode: volume_mode,
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

          # test all volumes based on PVCs
          volumes = @service.volumes.all
          volume = volumes.detect { |v| v.name == name }
          refute_nil(volume)
          assert_equal(volume.name, 'my-local-storage-pvc')
          assert_equal(volume.type, 'persistentVolumeClaim')
       ensure
         @service.pvcs.delete(name) if pvc
       end
     end
   end
 end
