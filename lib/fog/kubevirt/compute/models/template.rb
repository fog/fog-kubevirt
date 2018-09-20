module Fog
  module Kubevirt
    class Compute
      class Template < Fog::Model
        include Shared
        identity :name,              :aliases => 'metadata_name'

        attribute :namespace,        :aliases => 'metadata_namespace'
        attribute :description,      :aliases => 'metadata_description'
        attribute :tags,             :aliases => 'metadata_tags'
        attribute :labels,           :aliases => 'metadata_labels'
        attribute :resource_version, :aliases => 'metadata_resource_version'
        attribute :uid,              :aliases => 'metadata_uid'
        attribute :annotations,      :aliases => 'metadata_annotations'
        attribute :objects
        attribute :parameters

        def clone(options = {})
          params = values(options)

          # use persistent volume claims if any from a template and send
          create_persistent_volume_claims(persistent_volume_claims_from_objects(objects), params, namespace)

          # use vm definition from a template and send
          create_vm(vm_from_objects(objects), params, namespace)
        end

        def self.parse(object)
          metadata = object[:metadata]
          annotations = metadata[:annotations]
          {
            :namespace        => metadata[:namespace],
            :annotations      => metadata[:annotations],
            :name             => metadata[:name],
            :labels           => metadata[:labels],
            :resource_version => metadata[:resourceVersion],
            :uid              => metadata[:uid],
            :objects          => object[:objects],
            :parameters       => object[:parameters],
            :description      => annotations && annotations[:description],
            :tags             => annotations && annotations[:tags]
          }
        end

        private

        #
        # Combines default values of the parameters defined in a template with values
        # provided by the user on the UI.
        #
        # @param options [Hash] Hash containing values defined by the user on the UI.
        #
        def values(options)
          default_params = {}
          parameters.each do |param|
            name = param[:name].downcase
            value = options[name.to_sym]
            if value && name == "memory"
              value = value.to_s + 'Mi'
            end

            default_params[name] = value || param[:value]
          end
          default_params
        end

        #
        # Creates a virtual machine within provided namespace.
        #
        # @param vm [Hash] Virtual machine hash as defined in the template.
        # @param params [Hash] Containing mapping of name and value.
        # @param namespace [String] Namespace used to store the object.
        #
        def create_vm(vm, params, namespace)
          vm = param_substitution!(vm, params)
          os_labels = labels || {}
          vm = deep_merge!(vm,
            :spec     => {
              :running  => false
            },
            :metadata => {
              :namespace => namespace
            }
          )

          vm = deep_merge!(vm,
            :metadata => {
              :labels => {
                OS_LABEL => os_labels[OS_LABEL_SYMBOL]
              }
            }
          ) if os_labels[OS_LABEL_SYMBOL]

          # Send the request to create the virtual machine:
          vm = service.create_vm(vm)
        end

        #
        # Creates an persistent volume claims within provided namespace.
        #
        # @param pvcs Array[Hash] An array of pvc hashes as defined in the template.
        # @param params [Hash] Containing mapping of name and value.
        # @param namespace [String] Namespace used to store the object.
        #
        def create_persistent_volume_claims(pvcs, params, namespace)
          pvcs.each do |pvc|
            pvc = param_substitution!(pvc, params)

            pvc = deep_merge!(pvc,
              :metadata => {
                :namespace => namespace
              }
            )

            # Send the request to create the persistent volume claim:
            service.create_pvc(pvc)
          end
        end

        #
        # Returns object of `VirtualMachine` kind from provided objects.
        #
        # @param objects Array[Object] Objects defined in the template.
        # @return [Hash] Virtual machine hash
        #
        def vm_from_objects(objects)
          vm = nil
          objects.each do |object|
            if object[:kind] == "VirtualMachine"
              vm = object
            end
          end
          # make sure there is one
          raise ::Fog::Kubevirt::Errors::ServiceError if vm.nil?
          vm
        end

        #
        # Returns object of `PersistentVolumeClaim` kind from provided objects.
        #
        # @param objects Array[Object] Objects defined in the template.
        # @return Array[Hash] An array of pvc hashes.
        #
        def persistent_volume_claims_from_objects(objects)
          pvcs = []
          objects.each do |object|
            if object[:kind] == "PersistentVolumeClaim"
              pvcs << object
            end
          end
          pvcs
        end

        #
        # Performs parameter substitution for specific object where we
        # substitute ${params.key} with params[key].
        #
        # @param object [Hash | Array | String] Specific object where substitution takes place.
        # @param params [Hash] Hash containing parameters to be substituted.
        #
        def param_substitution!(object, params)
          result = object
          case result
          when Hash
            result.each do |k, v|
              result[k] = param_substitution!(v, params)
            end
          when Array
            result.map { |v| param_substitution!(v, params) }
          when String
            result = sub_specific_object(params, object)
          end
          result
        end

        #
        # Performs substitution on specific object.
        #
        # @params params [Hash] Containing parameter names and values used for substitution.
        # @params object [String] Object on which substitution takes place.
        # @returns [String] The outcome of substitution.
        #
        def sub_specific_object(params, object)
          result = object
          params.each_key do |name|
            token = "${#{name.upcase}}"
            os_token = "${{#{name.upcase}}}"
            next unless (object.include?(token) || object.include?(os_token))
            result = if params[name].kind_of?(String)
                       if object.include?(os_token)
                         object.sub!(os_token, params[name])
                       else
                         object.sub!(token, params[name])
                       end
                     else
                       params[name]
                     end
          end
          result
        end
      end
    end
  end
end
