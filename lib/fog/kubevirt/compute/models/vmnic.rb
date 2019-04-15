module Fog
  module Kubevirt
    class Compute
      class VmNic < Fog::Model
        identity :mac_address
        attr_accessor :name

        attribute :type # values: bridge, slirp
        attribute :model
        attribute :ports
        attribute :boot_order
        attribute :network
        attribute :cni_provider
        alias :mac :mac_address

        def persisted?
          !name.nil?
        end
      end
    end
  end
end