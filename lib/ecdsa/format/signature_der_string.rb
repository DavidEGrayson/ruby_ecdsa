require 'openssl'
require_relative '../signature'

module ECDSA
  module Format
    # This module provides methods to convert between {Signature} objects and their
    # binary DER representation.  The format used is defined in
    # [RFC 3278 section 8.2](http://tools.ietf.org/html/rfc3278#section-8.2).
    module SignatureDerString
      # Converts a DER string to a {Signature}.
      # @param der_string (String)
      # @return (Signature)
      def self.decode(der_string)
        asn1 = OpenSSL::ASN1.decode(der_string)
        r = asn1.value[0].value.to_i
        s = asn1.value[1].value.to_i
        Signature.new(r, s)
      end

      # Converts a {Signature} to a DER string.
      # @param signature (Signature)
      # @return (String)
      def self.encode(signature)
        asn1 = OpenSSL::ASN1::Sequence.new [
          OpenSSL::ASN1::Integer.new(signature.r),
          OpenSSL::ASN1::Integer.new(signature.s),
        ]
        asn1.to_der
      end
    end
  end
end
