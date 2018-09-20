require 'recursive_open_struct'

module Fog
  module Kubevirt
    class Compute
      class Real
        def get_node(name)
          Node.parse object_to_hash( kube_client.get_node(name) )
        end
      end

      class Mock
        def get_node(name)
          node = {:apiVersion => "v1",
                  :kind => "Node",
                  :metadata => {
                    :annotations => {
                      :volumes.kubernetes.io/controller-managed-attach-detach => "true"
                    },
                    :creationTimestamp => "2018-04-09T15:34:26Z",
                    :labels => {
                      :beta.kubernetes.io/arch => "amd64", :beta.kubernetes.io/os => "linux",
                      :kubernetes.io/hostname => "master", :node-role.kubernetes.io/master => "true",
                      :openshift-infra => "apiserver", :region => "infra", :zone => "default"
                    },
                    :name => "master",
                    :resourceVersion => "1514501",
                    :selfLink => "/api/v1/nodes/master",
                    :uid => "7c4102a6-3c0b-11e8-ad43-525400a36119"
                  },
                  :spec => {
                    :externalID => "master"
                  },
                  :status => {
                    :addresses => [
                      {:address => "192.168.200.2", :type => "InternalIP"},
                      {:address => "master", :type => "Hostname"}
                    ],
                    :allocatable => {:cpu => "2", :memory => "2739328Ki", :pods => "20"},
                    :capacity => {:cpu => "2", :memory => "2841728Ki", :pods => "20"},
                    :conditions => [
                      {
                        :lastHeartbeatTime => "2018-04-20T09:37:45Z", :lastTransitionTime => "2018-04-09T15:34:26Z",
                        :message => "kubelet has sufficient disk space available", :reason => "KubeletHasSufficientDisk",
                        :status => "False", :type => "OutOfDisk"
                      },
                      {
                        :lastHeartbeatTime => "2018-04-20T09:37:45Z", :lastTransitionTime => "2018-04-09T15:34:26Z",
                        :message => "kubelet has sufficient memory available", :reason => "KubeletHasSufficientMemory",
                        :status => "False", :type => "MemoryPressure"
                      },
                      {
                        :lastHeartbeatTime => "2018-04-20T09:37:45Z", :lastTransitionTime => "2018-04-19T12:56:17Z",
                        :message => "kubelet has disk pressure", :reason => "KubeletHasDiskPressure",
                        :status => "True", :type => "DiskPressure"
                      },
                      {
                        :lastHeartbeatTime => "2018-04-20T09:37:45Z", :lastTransitionTime => "2018-04-20T07:08:18Z",
                        :message => "kubelet is posting ready status", :reason => "KubeletReady",
                        :status => "True", :type => "Ready"
                      }
                    ],
                    :daemonEndpoints => {
                      :kubeletEndpoint => {
                        :Port => 10250
                      }
                    },
                    :images => [
                      {
                        :names => ["docker.io/openshift/openvswitch@sha256:2783e9bc552ea8c4ea725a9f88e353330243b010925c274561ba045974ce4000",
                                   "docker.io/openshift/openvswitch:v3.9.0-alpha.4"], :sizeBytes => 1474465582
                      },
                      {
                        :names => ["docker.io/openshift/node@sha256:e092f1267535714070761844a62cdd38ce05e63a836ee55196953b8ac69527ba",
                                   "docker.io/openshift/node:v3.9.0-alpha.4"], :sizeBytes => 1472685816
                      },
                      {
                        :names => ["docker.io/openshift/origin@sha256:4a3d8819499307c57dbb7d244b719c0e45068ca54727ef30b53a361cbe7d9430",
                                   "docker.io/openshift/origin:v3.9.0-alpha.4"], :sizeBytes => 1257103966
                      },
                      {
                        :names => ["docker.io/ansibleplaybookbundle/apb-base@sha256:639d623b8185dd1471d38d2cc554efe7e2440a69d9a44cefa6b5565e8cc0d89c",
                                   "docker.io/ansibleplaybookbundle/apb-base:latest"], :sizeBytes => 658504560
                      },
                      {
                        :names => ["registry.fedoraproject.org/latest/etcd@sha256:0656877d3888ca8b385bfc720fede845de185f0b5d29a0bbc7a2fb8c6fc8137a",
                                   "registry.fedoraproject.org/latest/etcd:latest"], :sizeBytes => 308700638
                      },
                      {
                        :names => ["docker.io/fedora@sha256:7e2fc11763119c0cc0781400bb571bf2033c45469ebe286f1f090ba0dcffc32e",
                                   "docker.io/fedora:26"], :sizeBytes => 231669643
                      },
                      {
                        :names => ["docker.io/openshift/origin-pod@sha256:ba180ba987ad1f07187c35e2369923b04fb8969a4344064feb38de508d65c385",
                                   "docker.io/openshift/origin-pod:v3.9.0-alpha.4"], :sizeBytes => 228576414
                      }
                    ],
                    :nodeInfo => {
                      :architecture => "amd64", :bootID => "c2c59d3a-79d4-4661-acff-daf685ae4edc", :containerRuntimeVersion => "docker://1.13.1",
                      :kernelVersion => "3.10.0-693.21.1.el7.x86_64", :kubeProxyVersion => "v1.9.1+a0ce1bc657", :kubeletVersion => "v1.9.1+a0ce1bc657",
                      :machineID => "52c01ad890e84b15a1be4be18bd64ecd", :operatingSystem => "linux", :osImage => "CentOS Linux 7 (Core)",
                      :systemUUID => "52C01AD8-90E8-4B15-A1BE-4BE18BD64ECD"
                    }
                  }
          }
          object = RecursiveOpenStruct.new(node, recurse_over_arrays: true)
          Node.parse object_to_hash(object)
        end
      end
    end
  end
end
