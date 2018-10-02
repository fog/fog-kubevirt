module Fog
  module Kubevirt
    class Compute
      class Real
        def get_template(name)
          Template.parse object_to_hash( openshift_client.get_template(name, @namespace) )
        end
      end

      class Mock
        # TODO provide implementation
        def get_template(name)
        end
      end
    end
  end
end
