require 'fog/core/collection'
require 'fog/compute/kubevirt/models/vm'

module Fog
  module Compute
    class Kubevirt
      class Vms < Fog::Collection
        include Shared

        attr_reader :kind, :resource_version

        model Fog::Compute::Kubevirt::Vm

        def all(filters = {})
          begin
            vms = service.list_vms(filters)
          rescue ::Fog::Kubevirt::Errors::ClientError
            # we assume that we get 404
            vms = []
          end
          @kind = vms.kind
          @resource_version = vms.resource_version
          load vms
        end

        def get(name)
          new service.get_vm(name)
        end

        # Creates a virtual machine using provided paramters:
        # :vm_name [String] - name of a vm
        # :cpus [String] - number of cpus
        # :memory_size [String] - amount of memory
        # :image [String] - name of a registry disk
        # :pvc [String] - name of a persistent volume claim
        #
        # One of :image or :pvc needs to be provided.
        #
        # @param [Hash] attributes containing details about vm about to be
        #   created.
        def create(args = {})
          vm_name = args.fetch(:vm_name)
          cpus = args.fetch(:cpus, nil)
          memory_size = args.fetch(:memory_size)
          image = args.fetch(:image, nil)
          pvc = args.fetch(:pvc, nil)

          if image.nil? && pvc.nil?
            raise ::Fog::Kubevirt::Errors::ValidationError
          end
          
          volume = {}

          if !image.nil?
            volume = {
              :name => vm_name,
              :registryDisk => {
                :image => image
              }
            }
          else
            volume = {
              :name => vm_name,
              :persistentVolumeClaim => {
                :claimName => pvc
              }
            }
          end

          vm = {
            :apiVersion => service.class::KUBEVIRT_VERSION_LABEL,
            :kind => "VirtualMachine",
            :metadata => {
              :labels => {
                :"kubevirt.io/vm" => vm_name,
              },
              :name => vm_name,
              :namespace => service.namespace,
            },
            :spec => {
              :running => false,
              :template => {
                :metadata => {
                  :creationTimestamp => nil,
                  :labels => {
                    :"kubevirt.io/vm" => vm_name
                  }
                },
                :spec => {
                  :domain => {
                    :devices => {
                      :disks => [
                        {:disk => {
                           :bus => "virtio"
                         },
                         :name => vm_name,
                         :volumeName => vm_name
                        }
                      ]
                    },
                    :machine => {
                      :type => ""
                    },
                    :resources => {
                      :requests => {
                        :memory => "#{memory_size}M"
                      }
                    }
                  },
                  :terminationGracePeriodSeconds => 0,
                  :volumes => [volume]
                }
              }
            }
          }

          vm = deep_merge!(vm,
            :spec => {
              :template => {
                :spec => {
                  :domain => {
                    :cpu => {
                      :cores => cpus
                    }
                  }
                }
              }
            }
          ) unless cpus.nil?

          service.create_vm(vm)
        end
      end
    end
  end
end
