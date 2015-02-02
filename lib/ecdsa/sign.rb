module ECDSA
  # Produces an ECDSA signature.
  #
  # This algorithm comes from section 4.1.3 of [SEC1](http://www.secg.org/collateral/sec1_final.pdf).
  #
  # @param group (Group) The curve that is being used.
  # @param private_key (Integer) The private key.  (The number of times to add
  #   the generator point to itself to get the public key.)
  # @param digest (String or Integer)
  #   A digest of the message to be signed, usually generated with a hashing algorithm
  #   like SHA2.  The same algorithm must be used when verifying the signature.
  # @param temporary_key (Integer)
  #   A temporary private key.
  #   This is also known as "k" or "nonce".
  #   Warning: Never use the same `temporary_key` value twice for two different messages
  #   or else it will be easy for someone to calculate your private key.
  #   The `temporary_key` should be generated with a secure random number generator.
  # @return (Signature or nil)  Usually this method returns a {Signature}, but
  #   there is a very small chance that the calculated "s" value for the
  #   signature will be 0, in which case the method returns nil.  If that happens,
  #   you should generate a new temporary key and try again.
  def self.sign(group, private_key, digest, temporary_key)
    # TODO: add an option for specifying that the s value should be low,
    #  which is needed by systems like Bitcoin:  https://github.com/bitcoin/bips/blob/master/bip-0062.mediawiki#low-s-values-in-signatures

    # Second part of step 1: Select ephemeral elliptic curve key pair
    # temporary_key was already selected for us by the caller
    r_point = group.new_point temporary_key

    # Steps 2 and 3
    point_field = PrimeField.new(group.order)
    r = point_field.mod(r_point.x)
    return nil if r.zero?

    # Step 4, calculating the hash, was already performed by the caller.

    # Step 5
    e = normalize_digest(digest, group.bit_length)

    # Step 6
    s = point_field.mod(point_field.inverse(temporary_key) * (e + r * private_key))
    return nil if s.zero?

    Signature.new r, s
  end
end
