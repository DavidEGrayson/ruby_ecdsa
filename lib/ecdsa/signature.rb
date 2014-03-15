require 'openssl'

module ECDSA
  class Signature
    attr_reader :r
    attr_reader :s

    def initialize(der_string)
      asn1 = OpenSSL::ASN1.decode(der_string)
      @r = asn1.value[0].value.to_i
      @s = asn1.value[1].value.to_i
    end
  end
end