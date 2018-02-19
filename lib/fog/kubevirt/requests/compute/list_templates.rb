module Fog
  module Compute
    class Kubevirt
      class Real
        def list_templates(filters = {})
          client.get_templates(:namespace => 'default').map { |kubevirt_obj| to_hash kubevirt_obj }
        end
      end

      class Mock
        def list_templates(filters = {})
        end
      end
    end
  end
end
