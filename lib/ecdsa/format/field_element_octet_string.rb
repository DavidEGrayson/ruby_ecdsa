module ECDSA
  module Format
    # This module provides methods for converting elements of a field to octet
    # strings.  The conversions are defined in these sections of
    # [SEC1](http://www.secg.org/collateral/sec1_final.pdf):
    #
    # * Section 2.3.5: FieldElement-to-OctetString Conversion
    # * Section 2.3.6: OctetString-to-FieldElement Conversion
    module FieldElementOctetString
      # Converts a field element to an octet string.
      #
      # @param element (Integer) The integer to encode.
      # @param field (PrimeField)
      # @return (String)
      def self.encode(element, field)
        raise ArgumentError, 'Given element is not an element of the field.' if !field.include?(element)
        length = ECDSA.byte_length(field.prime)
        IntegerOctetString.encode(element, length)
      end

      # Converts an octet string to a field element.
      # Raises a {DecodeError} if the input string is invalid for any reason.
      #
      # @param string (String)
      # @param field (PrimeField)
      # @return (Integer)
      def self.decode(string, field)
        int = IntegerOctetString.decode(string)

        if !field.include?(int)
          # The integer has to be non-negative, so it must be too big.
          raise DecodeError, 'Decoded integer is too large for field: 0x%x >= 0x%x.' % [int, field.prime]
        end

        int
      end
    end
  end
end
