require 'fog/core/collection'
require 'fog/compute/kubevirt/models/storageclass'

module Fog
  module Compute
    class Kubevirt
      class Storageclasses < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Compute::Kubevirt::Storageclass

        def all(filters = {})
          storageclasses = service.list_storageclasses(filters)
          @kind = storageclasses.kind
          @resource_version = storageclasses.resource_version
          load storageclasses
        end

        def get(name)
          new service.get_storageclass(name)
        end

        # Creates a storage class using provided paramters:
        # https://kubernetes.io/docs/concepts/storage/storage-classes
        # :name [String] - name of a storage class
        # :parameters [Object] - parameters for the provisioner that should create volumes of this storage class
        # :mount_options [Arr] - mount options for the dynamically provisioned PersistentVolumes of this storage class.
        # :provisioner [String] - the type of the provisioner
        # :volume_binding_mode [String] - indicates how PersistentVolumeClaims should be provisioned and bound
        # :reclaim_policy [String] - the reclaim policy of the created PVs (Defaults to Delete).
        def create(args = {})
          storageclass = {
            :apiVersion => "storage.k8s.io/v1",
            :kind => "StorageClass",
            :metadata => {
              :name      => args[:name],
            },
            :parameters          => args[:parameters],
            :mount_options       => args[:mount_options],
            :provisioner         => args[:provisioner],
            :volume_binding_mode => args[:volume_binding_mode],
            :reclaim_policy      => args[:reclaim_policy]
          }

          service.create_storageclass(storageclass)
        end

        def delete(name)
          begin
            storageclass = get(name)
          rescue ::Fog::Kubevirt::Errors::ClientError
            # the storageclass doesn't exist
            storageclass = nil
          end

          service.delete_storageclass(name) unless storageclass.nil?
        end
      end
    end
  end
end
