require_relative 'ecdsa/group'
require_relative 'ecdsa/signature'

class String
  def hex_inspect
    '"' + each_byte.collect { |b| '\x%02x' % b}.join + '"'
  end
end

module ECDSA

  class InvalidSignatureError < StandardError
  end

  # Algorithm taken from http://www.secg.org/collateral/sec1_final.pdf Section 4.1.4.
  def self.valid_signature?(public_key, digest, signature)
    check_signature! public_key, digest, signature
  rescue InvalidSignatureError
    false
  end
  
  def self.check_signature!(public_key, digest, signature)
    group = public_key.group
    field = group.field
    
    # Step 1: r and s must be in the field and non-zero
    raise InvalidSignatureError, 'r value is not the field.' if !field.include?(signature.r)
    raise InvalidSignatureError, 's value is not the field.' if !field.include?(signature.s)
    raise InvalidSignatureError, 'r is zero.' if signature.r.zero?
    raise InvalidSignatureError, 's is zero.' if signature.s.zero?
    
    # Step 2 was already performed when the digest of the message was computed.
    
    # Step 3: Convert octet string to number.
    digest_num = convert_digest_to_integer(digest)    
    if group.bit_length < 8 * digest.size
      raise 'Have not yet written code to handle this case'
    else
      e = digest_num
    end
    
    # Step 4
    point_field = PrimeField.new(group.order)
    s_inverted = point_field.inverse(signature.s)
    u1 = point_field.mod(e * s_inverted)    
    u2 = point_field.mod(signature.r * s_inverted)
    
    # Step 5
    r = group.generator.multiply_by_scalar(u1).add_to_point public_key.multiply_by_scalar(u2)
    raise InvalidSignatureError, 'R is infinity in step 5.' if r.infinity?
    
    # Step 6
    xr = r.x
    
    # Step 7
    v = point_field.mod xr
    
    # Step 8
    raise InvalidSignatureError, 'v does not equal r.' if v != signature.r
    
    return true
  end
  
  def self.convert_digest_to_integer(digest)
    case digest
    when Integer then digest
    when String then convert_octet_string_to_bit_string(digest)
    else raise "Invalid digest: #{digest.inspect}"
    end
  end
  
  # SEC1, Section 2.3.2.
  # My interpretation of that section is that we treat the octet string as BIG endian.
  def self.convert_octet_string_to_bit_string(string)
    string.bytes.inject { |n, b| (n << 8) + b }
  end
end