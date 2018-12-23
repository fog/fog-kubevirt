require 'fog/core/collection'
require 'fog/kubevirt/compute/models/volume'

module Fog
  module Kubevirt
    class Compute
      class Volumes < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Volume

        def all(filters = {})
          volumes = service.list_volumes(filters)
          @kind = volumes.kind
          @resource_version = volumes.resource_version
          load volumes
        end

        def get(name)
          new service.get_volume(name)
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
          volume[:spec][args[:type].to_sym] = args[:config] if args[:type]

          service.create_volume(volume)
        end

        def delete(name)
          begin
            volume = get(name)
          rescue ::Fog::Kubevirt::Errors::ClientError
            # the volume doesn't exist
            volume = nil
          end

          service.delete_volume(name) unless volume.nil?
        end
      end
    end
  end
end
