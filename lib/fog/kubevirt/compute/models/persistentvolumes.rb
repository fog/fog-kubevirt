require 'fog/core/collection'
require 'fog/kubevirt/compute/models/persistentvolume'

module Fog
  module Kubevirt
    class Compute
      class Persistentvolumes < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Persistentvolume

        def all(filters = {})
          volumes = service.list_persistentvolumes(filters)
          @kind = volumes.kind
          @resource_version = volumes.resource_version
          load volumes
        end

        def get(name)
          new service.get_persistentvolume(name)
        end

        # Creates a volume using provided paramters:
        # :name [String] - name of a volume
        # :labels [Hash] - a hash of key,values representing the labels
        # :storage_class [String] - the storage class name of the volume
        # :capacity [String] - The capacity of the storage if applied
        # :accessModes [Arr] - the access modes for the volume, values are specified here:
        #    https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes
        # :type [String] - the type of the storage
        # :config [Hash] - storage specific configuration to be applied for the volume
        #    correlated to the args[:type]
        # @param [Hash] attributes containing details about volume to be created.
        def create(args = {})
          name = args[:name]
          labels = args[:labels]

          # type is required
          if args[:type].nil? || args[:type].empty?
            raise ::Fog::Kubevirt::Errors::ValidationError "Type of storage can not be empty"
          end

          volume = {
            :apiVersion => "v1",
            :kind => "PersistentVolume",
            :metadata => {
              :name      => name
            },
            :spec => {
              :storageClassName => args[:storage_class]
            }
          }

          volume[:metadata][:labels] = labels if labels
          volume[:spec][:capacity] = {
            :storage => args[:capacity]
          } if args[:capacity]

          volume[:spec][:accessModes] = args[:access_modes] if args[:access_modes]
          volume[:spec][args[:type].to_sym] = args[:config]

          service.create_persistentvolume(volume)
        end

        def delete(name)
          begin
            volume = get(name)
          rescue ::Fog::Kubevirt::Errors::ClientError
            # the volume doesn't exist
            volume = nil
          end

          service.delete_persistentvolume(name) unless volume.nil?
        end
      end
    end
  end
end
