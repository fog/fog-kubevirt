module Fog
  module Kubevirt
    module Utils
      #
      # This class contains functions performing unit calculations.
      # Originally implemented for manageiq-providers-kubevirt project
      #
      class UnitConverter

        #
        # Converts a value containing an optional unit to another unit. For example, if the value is
        # `2 MiB` and the unit is `KiB` the result will be 2048.
        #
        # @param value [String] The value to convert, with an optional unit suffix.
        # @param to [Symbol] (:b) The name of the unit to convert to, for example `:gib`.
        # @return [BigDecimal] The converted value.
        #
        def self.convert(value, to)
          # Return nil if no value is given:
          return nil unless value
  
          match = validate(value)
          value = match[:value]
          from = match[:suffix]
  
          # Convert the value from string to big decimal to make sure that we don't loose precission:
          value = BigDecimal(value)
  
          # Do the conversion:
          from_factor = scale_factor(from)
          to_factor = scale_factor(to)
          value * from_factor / to_factor
        end
  
        #
        # Validates and extracts the numeric value and the unit
        #
        # @param value [String] The value to validate with optional unit suffix.
        # @return [MatchData] describing the match, or ValidationError is raised if no match.
        #
        def self.validate(value)
          match = VALUE_RE.match(value)
          raise ::Fog::Kubevirt::Errors::ValidationError, "The value '#{value}' isn't a valid unit" unless match
  
          match
        end
  
        #
        # Regular expression used to match values and to separate them into the numeric value and the
        # optional unit suffix.
        #
        VALUE_RE = /^\s*(?<value>[[:digit:]]+)\s*(?<suffix>[[:alpha:]]+)?\s*$/i
        private_constant :VALUE_RE
  
        #
        # Scale factors associated to the different unit suffixes.
        #
        SCALE_FACTORS = {
          :b   => 1,
  
          :k   => 10**3,
          :m   => 10**6,
          :g   => 10**9,
          :t   => 10**12,
          :p   => 10**15,
          :e   => 10**18,
          :z   => 10**21,
          :y   => 10**24,
  
          :kb  => 10**3,
          :mb  => 10**6,
          :gb  => 10**9,
          :tb  => 10**12,
          :pb  => 10**15,
          :eb  => 10**18,
          :zb  => 10**21,
          :yb  => 10**24,
  
          :ki  => 2**10,
          :mi  => 2**20,
          :gi  => 2**30,
          :ti  => 2**40,
          :pi  => 2**50,
          :ei  => 2**60,
          :zi  => 2**70,
          :yi  => 2**80,
  
          :kib => 2**10,
          :mib => 2**20,
          :gib => 2**30,
          :tib => 2**40,
          :pib => 2**50,
          :eib => 2**60,
          :zib => 2**70,
          :yib => 2**80
        }.freeze
        private_constant :SCALE_FACTORS
  
        #
        # Finds the scale factor that matches the given unit suffix.
        #
        # @param sufix [Symbol, String] The unit suffix, as symbol or string. For example `MiB` or `:mib`.
        # @return [Integer] The scale factor corresponding to that unit.
        #
        def self.scale_factor(suffix)
          suffix = suffix.downcase.to_sym if suffix.kind_of?(String)
          factor = SCALE_FACTORS[suffix]
          raise ::Fog::Kubevirt::Errors::ValidationError, "The value '#{suffix}' isn't a valid unit suffix" unless factor
          factor
        end
        private_class_method :scale_factor
      end  
    end
  end
end