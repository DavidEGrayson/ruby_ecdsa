# Defined in http://www.secg.org/collateral/sec1_final.pdf
# section 2.3.5: FieldElement-to-OctetString Conversion

module ECDSA
  module Format
    module FieldElementOctetString
      # @param integer (Integer) The integer to encode
      # @param length (Integer) The number of bytes desired in the output string.
      def self.encode(element, field)
        raise ArgumentError, 'Given element is not an element of the field.' if !field.include?(element)
        length = ECDSA.byte_length(field.prime)
        IntegerOctetString.encode(element, length)
      end

      def self.decode(string, field)
        int = IntegerOctetString.decode(string)

        if !field.include?(int)
          # The integer has to be non-negative, so it must be too big.
          raise DecodeError, "Decoded integer is too large for field: 0x%x >= 0x%x." % [int, field.prime]
        end

        int
      end
    end
  end
end
