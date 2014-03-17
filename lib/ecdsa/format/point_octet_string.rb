# The point octet string format is defined in section 2.3.3 of
# http://www.secg.org/collateral/sec1_final.pdf

require_relative '../point'

module ECDSA
  module Format
    module PointOctetString
      def self.encode(point)
        return "\x00" if point.infinity?
      end
    end
  end
end