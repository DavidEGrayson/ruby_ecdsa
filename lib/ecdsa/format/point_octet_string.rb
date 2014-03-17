# encoding: US-ASCII

# The point octet string format is defined in http://www.secg.org/collateral/sec1_final.pdf .
# Section 2.3.3: EllipticCurvePoint-to-OctetString Conversion
# Section 2.3.4: OctetString-to-EllipticCurvePoint Conversion

require_relative '../point'

module ECDSA
  module Format
    module PointOctetString
      def self.encode(point, opts={})
        return "\x00" if point.infinity?

        if opts[:compression]
          start_byte = (point.y % 2) == 0 ? "\x02" : "\x03"
          start_byte + FieldElementOctetString.encode(point.x, point.group.field)
        else
          "\x04" +
            FieldElementOctetString.encode(point.x, point.group.field) +
            FieldElementOctetString.encode(point.y, point.group.field)
        end
      end

      def self.decode(string, group)
        raise DecodeError, 'Point octet string is empty.' if string.empty?

        case string[0].ord
        when 0
          check_length string, 1
          return group.infinity_point
        when 2
          decode_compressed string, group, 0
        when 3
          decode_compressed string, group, 1
        when 4
          decode_uncompressed string, group
        else
          raise DecodeError, 'Unrecognized start byte for point octet string: 0x%x' % string[0].ord
        end
      end

      private
      def self.decode_compressed(string, group, y_lsb)
        expected_length = 1 + group.byte_length
        check_length string, expected_length
      end
      
      def self.decode_uncompressed(string, group)
        expected_length = 1 + 2 * group.byte_length
        check_length string, expected_length
      end

      def self.check_length(string, expected_length)
        if string.length != expected_length
          raise DecodeError, "Expected point octet string to be length #{expected_length} but it was #{string.length}."
        end
      end
    end
  end
end