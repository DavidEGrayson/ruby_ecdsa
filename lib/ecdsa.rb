require_relative 'ecdsa/group'
require_relative 'ecdsa/signature'

module ECDSA

  class InvalidSignatureError < StandardError
  end

  # Algorithm taken from http://www.secg.org/collateral/sec1_final.pdf Section 4.1.4.
  def self.valid_signature?(public_key, digest, signature)
    check_signature! public_key, digest, signature
    true
  rescue InvalidSignatureError
    false
  end
  
  def self.check_signature!(public_key, digest, signature)
    group = public_key.group
    field = group.field
    
    # Rule 1: r and s must be in the field and non-zero
    raise InvalidSignatureError, 'r value is not the field.' if !field.include?(signature.r)
    raise InvalidSignatureError, 's value is not the field.' if !field.include?(signature.s)
    raise InvalidSignatureError, 'r is zero.' if signature.r.zero?
    raise InvalidSignatureError, 's is zero.' if signature.s.zero?
    
    digest_num = convert_octet_string_to_bit_string(digest)
    
    raise 'not done'
  end
  
  # SEC1, Section 2.3.2.
  # My interpretation of that section is that we treat the octet string as BIG endian.
  def self.convert_octet_string_to_bit_string(string)
    string.bytes.inject { |n, b| (n << 8) + b }
  end
end