# Defined in http://www.secg.org/collateral/sec1_final.pdf :
# Section 2.3.7: Integer-to-OctetString Conversion
# Section 2.3.8: OctetString-to-Integer Conversion

module ECDSA
  module Format
    module IntegerOctetString
      # @param integer (Integer) The integer to encode
      # @param length (Integer) The number of bytes desired in the output string.
      def self.encode(integer, length)
        raise ArgumentError, 'Integer to encode is negative.' if integer < 0
        raise ArgumentError, 'Integer to encode is too large.' if integer >= (1 << (8*length))

        length.pred.downto(0).map do |i|
          integer >> (8*i)
        end.pack('C*')
      end

      def self.decode(string)
        integer = 0
        string.each_byte do |b|
          integer = (integer << 8) + b.ord
        end
        integer
      end
    end
  end
end
