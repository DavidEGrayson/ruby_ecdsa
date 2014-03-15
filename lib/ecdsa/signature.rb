require 'openssl'

module ECDSA
  class Signature
    attr_reader :r
    attr_reader :s

    def initialize(arg)
      case arg
      when String
        # arg is a DER string
        asn1 = OpenSSL::ASN1.decode(arg)
        @r = asn1.value[0].value.to_i
        @s = asn1.value[1].value.to_i
      when Array
        @r, @s = arg
      end
      
      @r.is_a?(Integer) or raise ArgumentError, 'r is not an integer'
      @s.is_a?(Integer) or raise ArgumentError, 's is not an integer'
    end
  end
end