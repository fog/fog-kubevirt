module Fog
  module Kubevirt
    class Compute
      module VmData

        class VmNetwork
          attr_accessor :name,
                        :type # values: multus, pod, genie
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
