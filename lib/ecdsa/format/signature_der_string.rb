require 'openssl'
require_relative '../signature'

module ECDSA
  module Format
    module SignatureDerString
      def self.decode(der_string)
        asn1 = OpenSSL::ASN1.decode(der_string)
        r = asn1.value[0].value.to_i
        s = asn1.value[1].value.to_i
        Signature.new(r, s)
      end

      def self.encode(signature)
        ra = OpenSSL::ASN1::Integer.new signature.r
        sa = OpenSSL::ASN1::Integer.new signature.s
        asn1 = OpenSSL::ASN1::Sequence.new [ra, sa]
        asn1.to_der
      end
    end
  end
end
