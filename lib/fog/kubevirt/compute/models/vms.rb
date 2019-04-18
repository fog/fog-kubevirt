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

        def new(attributes = {})
          vm = super
          vm.disks = [] unless vm.disks
          vm.volumes = [] unless vm.volumes
          vm.interfaces = [] unless vm.interfaces
          vm.networks = [] unless vm.networks
          vm
        end

        def get(name)
          new service.get_vm(name)
        end

        def delete(name)
          service.delete_vm(name, service.namespace)
        end

        # Creates a virtual machine using provided paramters:
        # :vm_name [String] - name of a vm
        # :cpus [String] - number of cpus
        # :memory_size [String] - amount of memory
        # :image [String] - name of a container disk
        # :pvc [String] - name of a persistent volume claim
        # :cloudinit [Hash] - number of items needed to configure cloud-init
        # :networks[Array] - networks to which the vm should be connected, i.e:
        #    [ { :name => 'default', :pod => {} } ,
        #      { :name => 'ovs-red', :multus => { :networkName => 'red'} }
        #    ]
        #
        # :interfaces[Array] - network interfaces for the vm, correlated to
        #                      :networks section by network's name, i.e.:
        #   [ { :name => 'default', :bridge => {} },
        #     { :name       => 'red',  # correlated to networks[networkName]
        #       :bridge     => {},
        #       :bootOrder  => 1,      # 1 to boot from network interface
        #       :macAddress => '12:34:56:AB:CD:EF' }
        #   ]
        #
        # @param [String] :image name of container disk.
        #
        # @param [Array] :volumes the volumes (Fog::Kubevirt::Compute::Volume) to be used by the VM
        #
        # @param [Hash] attributes containing details about vm about to be
        #   created.
        def create(args = {})
          vm_name = args.fetch(:vm_name)
          cpus = args.fetch(:cpus, nil)
          memory_size = args.fetch(:memory_size)
          init = args.fetch(:cloudinit, {})
          networks = args.fetch(:networks, nil)
          interfaces = args.fetch(:interfaces, nil)
          vm_volumes =  args.fetch(:volumes, nil)

          if vm_volumes.nil? || vm_volumes.empty?
            raise ::Fog::Kubevirt::Errors::ValidationError
          end

          volumes, disks = add_vm_storage(vm_name, vm_volumes)

          unless init.empty?
            volumes.push(:cloudInitNoCloud => init, :name => "cloudinitvolume")
          end

          vm = {
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
                      :disks => disks
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
            :name => "cloudinitvolume",
          ) unless init.empty?

          vm = deep_merge!(vm,
            :spec => {
              :template => {
                :spec => {
                  :networks => networks
                }
              }
            }
          ) unless networks.nil?

          vm = deep_merge!(vm,
            :spec => {
              :template => {
                :spec => {
                  :domain => {
                    :devices => {
                      :interfaces => interfaces
                    }
                  }
                }
              }
            }
          ) unless interfaces.nil?
          service.create_vm(vm)
        end

        def add_vm_storage(vm_name, vm_volumes)
          normalized_vm_name = vm_name.gsub(/[._]+/,'-')
          volumes, disks = [], []
          vm_volumes.each_with_index do |v, idx|
            volume_name = v.name || normalized_vm_name + "-disk-0" + idx.to_s
            disk = {
              :name => volume_name,
              :disk => {}
            }
            disk[:bootOrder] = v.boot_order if v.boot_order

            if v.type == 'containerDisk'
              # set image
              if v.config.nil?
                volumes.push(:name => volume_name, :containerDisk => {:image => v.info})
              else
                volumes.push(:name => volume_name, v.type.to_sym => v.config)
              end
              disk[:disk][:bus] = v.bus || "virtio"
            elsif v.type == 'persistentVolumeClaim'
              # set claim
              if v.config.nil?
                volumes.push(:name => volume_name, :persistentVolumeClaim => {:claimName => v.info})
              else
                volumes.push(:name => volume_name, v.type.to_sym => v.config)
              end
              disk[:disk][:bus] = v.bus || "virtio"
            else
              # convert type into symbol and pass :config as volume content
              volumes.push(:name => volume_name, v.type.to_sym => v.config)
              disk[:disk][:bus] = v.bus if v.bus
            end
            disks.push(disk)
          end

          return volumes, disks
        end
      end
    end
  end
end
