module Fog
  module Kubevirt
    class Compute
      module VmData

        class VmNetwork
          attr_accessor :name, # inner name used to map to interface
                        :type, # values: multus, pod, genie
                        :network_name # name of network attachment definition
        end

        class VmDisk
          attr_accessor :name,
                        :boot_order,
                        :type, # values: cdrom, disk, floppy, lun
                        :bus,
                        :readonly
        end
      end
    end
  end
end
