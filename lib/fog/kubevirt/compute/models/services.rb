require 'fog/core/collection'
require 'fog/kubevirt/compute/models/service'

module Fog
  module Kubevirt
    class Compute
      class Services < Fog::Collection
        attr_reader :kind, :resource_version

        model Fog::Kubevirt::Compute::Service

        def all(filters = {})
          begin
            srvs = service.list_services(filters)

            @kind = srvs.kind
            @resource_version = srvs.resource_version
          rescue ::Fog::Kubevirt::Errors::ClientError
            # we assume that we get 404
            srvs = []

            @kind = 'Service'
          end

          load srvs
        end

        def get(name)
          new service.get_service(name)
        end

        # Creates a service using provided paramters:
        # :name [String] - name of a service
        # :port [int] - a port which will be exposed on node and cluster
        # :target_port [int] - a vmi port which will be forwarded
        # :vmi_name [String] - name of a vmi to be selected
        # :service_type [String] - service type used to create service
        #
        # @param [Hash] attributes containing details about service to be
        #   created.
        def create(args = {})
          port = args[:port]
          name = args[:name]
          target_port = args[:target_port]
          vmi_name = args[:vmi_name]
          service_type = args[:service_type]

          srv = {
            :apiVersion => "v1",
            :kind => "Service",
            :metadata => {
              :name      => name,
              :namespace => service.namespace
            },
            :spec => {
              :externalTrafficPolicy => "Cluster",
              :ports => [
                {:nodePort   => port,
                 :port       => port,
                 :protocol   => "TCP",
                 :targetPort => target_port
                }
              ],
              :selector => {
                :"kubevirt.io/vm" => vmi_name
              },
              :type => service_type
            }
          }

          service.create_service(srv)
        end

        def delete(name)
          begin
            srv = get(name)
          rescue ::Fog::Kubevirt::Errors::ClientError
            # the service doesn't exist
            srv = nil
          end

          service.delete_service(name, service.namespace) unless srv.nil?
        end
      end
    end
  end
end
