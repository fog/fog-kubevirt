module Fog
  module Kubevirt
    class Compute
      class Real
        def create_pvc(pvc)
          kube_client.create_persistent_volume_claim(pvc)
        rescue ::Fog::Kubevirt::Errors::ClientError => err
          log.warn(err)
          raise ::Fog::Kubevirt::Errors::AlreadyExistsError
        end
      end

      class Mock
        def create_pvc(attrs);
          if attrs == {:apiVersion=>"v1", :kind=>"PersistentVolumeClaim", :metadata=>{:name=>"claimski1", :namespace=>"default"}, :spec=>{:storageClassName=>"local-storage", :resources=>{:requests=>{:storage=>"3G"}}, :selector=>{}, :accessModes=>["ReadWriteOnce"]}}
            #<Kubeclient::Resource kind="PersistentVolumeClaim", apiVersion="v1", metadata={:name=>"claimski1", :namespace=>"default", :selfLink=>"/api/v1/namespaces/default/persistentvolumeclaims/claimski1", :uid=>"f3877a2c-55ee-11e9-9132-525400c5a686", :resourceVersion=>"887623", :creationTimestamp=>"2019-04-03T09:00:38Z"}, spec={:accessModes=>["ReadWriteOnce"], :selector=>{}, :resources=>{:requests=>{:storage=>"3G"}}, :storageClassName=>"local-storage", :volumeMode=>"Filesystem", :dataSource=>nil}, status={:phase=>"Pending"}>
            result = Kubeclient::Resource.new()
            result.kind = "PersistentVolumeClaim"
            result.apiVersion="v1"
            result.metadata = {:name=>"claimski1", :namespace=>"default", :selfLink=>"/api/v1/namespaces/default/persistentvolumeclaims/claimski1", :uid=>"f3877a2c-55ee-11e9-9132-525400c5a686", :resourceVersion=>"887623", :creationTimestamp=>"2019-04-03T09:00:38Z"}
            result.spec = {:accessModes=>["ReadWriteOnce"], :selector=>{}, :resources=>{:requests=>{:storage=>"3G"}}, :storageClassName=>"local-storage", :volumeMode=>"Filesystem", :dataSource=>nil}
            result.status = {:phase=>"Pending"}>
            result
          end
        end
      end
    end
  end
end
