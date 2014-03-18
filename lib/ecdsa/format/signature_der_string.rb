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
    end
  end
end