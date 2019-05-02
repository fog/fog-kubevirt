module Fog
  module Kubevirt
    class Compute
      class Real
        def create_pvc(pvc)
          kube_client.create_persistent_volume_claim(pvc)
        end
      end

      class Mock
        def create_pvc(attrs)
          attrs_set_1g = {:apiVersion=>"v1",
                          :kind=>"PersistentVolumeClaim",
                          :metadata=>{:name=>"robin-rykert-example-com-claim-1",
                                      :namespace=>"default"},
                                      :spec=>{:storageClassName=>"local-storage",
                                              :resources=>{:requests=>{:storage=>"1G"}},
                                              :selector=>{},
                                              :accessModes=>["ReadWriteOnce"]}}
          if attrs == attrs_set_1g
            result = Kubeclient::Resource.new
            result.kind = "PersistentVolumeClaim"
            result.apiVersion="v1"
            result.metadata = {:name=>"robin-rykert-example-com-claim-1",
                               :namespace=>"default",
                               :selfLink=>"/api/v1/namespaces/default/persistentvolumeclaims/robin-rykert-example-com-claim-1",
                               :uid=>"00a7e1d7-5875-11e9-9132-525400c5a686",
                               :resourceVersion=>"1020273",
                               :creationTimestamp=>"2019-04-06T14:05:15Z"}
            result.spec = {:accessModes=>["ReadWriteOnce"],
                           :selector=>{},
                           :resources=>{:requests=>{:storage=>"1G"}},
                           :storageClassName=>"local-storage",
                           :volumeMode=>"Filesystem",
                           :dataSource=>nil}
            result.status = {:phase=>"Pending"}
            return result
          end

          attrs_set_2g = {:apiVersion=>"v1",
                          :kind=>"PersistentVolumeClaim",
                          :metadata=>{:name=>"robin-rykert-example-com-claim-2",
                                      :namespace=>"default"},
                                      :spec=>{:storageClassName=>"local-storage",
                                              :resources=>{:requests=>{:storage=>"2G"}},
                                              :selector=>{},
                                              :accessModes=>["ReadWriteOnce"]}}
          if attrs == attrs_set_2g
            result = Kubeclient::Resource.new
            result.kind="PersistentVolumeClaim"
            result.apiVersion="v1"
            result.metadata = {:name=>"robin-rykert-example-com-claim-2",
                               :namespace=>"default",
                               :selfLink=>"/api/v1/namespaces/default/persistentvolumeclaims/robin-rykert-example-com-claim-2",
                               :uid=>"00aa08ba-5875-11e9-9132-525400c5a686",
                               :resourceVersion=>"1020274",
                               :creationTimestamp=>"2019-04-06T14:05:15Z"}
            result.spec = {:accessModes=>["ReadWriteOnce"],
                           :selector=>{},
                           :resources=>{:requests=>{:storage=>"2G"}},
                           :storageClassName=>"local-storage",
                           :volumeMode=>"Filesystem",
                           :dataSource=>nil}
            result.status = {:phase=>"Pending"}
            return result
          end

          attrs_set_1g_image = {:apiVersion=>"v1",
                                :kind=>"PersistentVolumeClaim",
                                :metadata=>{:name=>"olive-kempter-example-com-claim-1",
                                            :namespace=>"default"},
                                            :spec=>{:storageClassName=>"local-storage",
                                                    :resources=>{:requests=>{:storage=>"1G"}},
                                                    :selector=>{},
                                                    :accessModes=>["ReadWriteOnce"]}}

          if attrs == attrs_set_1g_image
            result = Kubeclient::Resource.new
            result.kind="PersistentVolumeClaim"
            result.apiVersion="v1"
            result.metadata={:name=>"olive-kempter-example-com-claim-1",
                             :namespace=>"default",
                             :selfLink=>"/api/v1/namespaces/default/persistentvolumeclaims/olive-kempter-example-com-claim-1",
                             :uid=>"d4d63298-5945-11e9-9132-525400c5a686",
                             :resourceVersion=>"1075554",
                             :creationTimestamp=>"2019-04-07T15:00:06Z"}
            result.spec={:accessModes=>["ReadWriteOnce"],
                         :selector=>{},
                         :resources=>{:requests=>{:storage=>"1G"}},
                         :storageClassName=>"local-storage",
                         :volumeMode=>"Filesystem",
                         :dataSource=>nil}
            result.status={:phase=>"Pending"}
            result
          end
        end
      end
    end
  end
end
