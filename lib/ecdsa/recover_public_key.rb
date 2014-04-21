module ECDSA
  # Recovers the set of possible public keys from a {Signature} and the digest
  # that it signs.
  #
  # If you do not pass a block to `recover_public_key` then it returns an
  # Enumerator that will lazily find more public keys when needed.  If you
  # are going to iterate through the enumerator more than once, you should
  # probably convert it to an array first with `to_a` to save CPU time.
  #
  # If you pass a block, it will yield the public keys to the block one at a
  # time as it finds them.
  #
  # This is better than just returning an array of all possibilities, because
  # it allows the caller to stop the algorithm when the desired public key has
  # been found, saving CPU time.
  #
  # This algorithm comes from Section 4.1.6 of [SEC1 2.0](http://www.secg.org/download/aid-780/sec1-v2.pdf)
  #
  # @param group (Group)
  # @param digest (String or Integer)
  # @param signature (Signature)
  def self.recover_public_key(group, digest, signature)
    return enum_for(:recover_public_key, group, digest, signature) if !block_given?

    digest = normalize_digest(digest, group.bit_length)

    each_possible_temporary_public_key(group, digest, signature) do |point|
      yield calculate_public_key(group, digest, signature, point)
    end

    nil
  end

  private

  def self.each_possible_temporary_public_key(group, digest, signature)
    # Instead of using the cofactor as the iteration limit as specified in SEC1,
    # we just iterate until x is too large to fit in the underlying field.
    # That way we don't have to know the cofactor of the group.
    signature.r.step(group.field.prime - 1, group.order) do |x|
      group.solve_for_y(x).each do |y|
        point = group.new_point [x, y]
        yield point if point.multiply_by_scalar(group.order).infinity?
      end
    end
  end

  # Assuming that we know the public key corresponding to the (random) temporary
  # private key used during signing, this method tells us what the actual
  # public key was.
  def self.calculate_public_key(group, digest, signature, temporary_public_key)
    point_field = PrimeField.new(group.order)

    # public key = (tempPubKey * s - G * e) / r
    rs = temporary_public_key.multiply_by_scalar(signature.s)
    ge = group.generator.multiply_by_scalar(digest)
    r_inv = point_field.inverse(signature.r)

    rs.add_to_point(ge.negate).multiply_by_scalar(r_inv)
  end
end
