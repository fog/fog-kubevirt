require 'fog/core/collection'
require 'fog/kubevirt/compute/models/vm'

module Fog
  module Kubevirt
    class Compute
      class Vms < Fog::Collection
        include Shared

        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Vm

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
        # :cloudinit [Hash] - number of items needed to configure cloud-init
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
          init = args.fetch(:cloudinit, {})

          if image.nil? && pvc.nil?
            raise ::Fog::Kubevirt::Errors::ValidationError
          end
          
          volumes = []

          if !image.nil?
            volumes.push(:name => vm_name, :registryDisk => {:image => image})
          else
            volumes.push(:name => vm_name, :persistentVolumeClaim => {:claimName => pvc})
          end

          unless init.empty?
            volumes.push(:cloudInitNoCloud => init, :name => "cloudinitvolume")
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
                  :volumes => volumes
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

          vm[:spec][:template][:spec][:domain][:devices][:disks].push(
            :disk => {
              :bus => "virtio"
            },
            :name => "cloudinitdisk",
            :volumeName => "cloudinitvolume"
          ) unless init.empty?

          service.create_vm(vm)
        end
      end
    end
  end
end
