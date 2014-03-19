# Defined in http://www.secg.org/collateral/sec1_final.pdf :
# Section 2.3.7: Integer-to-OctetString Conversion
# Section 2.3.8: OctetString-to-Integer Conversion
#
# We use integers to represent bit strings, so this module can
# also be thought of as implementing these sections:
# Section 2.3.1: BitString-to-OctetString Conversion
# Section 2.3.2: OctetString-to-BitString Conversion

module ECDSA
  module Format
    module IntegerOctetString
      # @param integer (Integer) The integer to encode
      # @param length (Integer) The number of bytes desired in the output string.
      def self.encode(integer, length)
        raise ArgumentError, 'Integer to encode is negative.' if integer < 0
        raise ArgumentError, 'Integer to encode is too large.' if integer >= (1 << (8 * length))

        length.pred.downto(0).map do |i|
          (integer >> (8 * i)) & 0xFF
        end.pack('C*')
      end

      def self.decode(string)
        string.bytes.reduce { |n, b| (n << 8) + b }
      end
    end
  end
end
