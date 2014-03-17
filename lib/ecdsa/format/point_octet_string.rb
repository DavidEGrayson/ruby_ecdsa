# encoding: US-ASCII

# The point octet string format is defined in section 2.3.3 of
# http://www.secg.org/collateral/sec1_final.pdf

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
    end
  end
end