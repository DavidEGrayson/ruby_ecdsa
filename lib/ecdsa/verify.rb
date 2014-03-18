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

    # Step 3: Convert octet string to number and take leftmost bits.
    e = normalize_digest(digest, group.bit_length)

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
end
