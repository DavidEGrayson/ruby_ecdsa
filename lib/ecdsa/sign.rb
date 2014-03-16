module ECDSA
  class SZeroError < StandardError
  end

  # From http://www.secg.org/collateral/sec1_final.pdf section 4.1.3
  # Warning: Never use the same k value twice for two different messages
  # or else it will be trivial for someone to calculate your private key.
  # k should be generated with a secure random number generator.
  def self.sign(group, private_key, digest, k)  
    # Second part of step 1: Select ephemeral elliptic curve key pair
    # k was already selected for us by the caller
    r_point = group.new_point k
    
    # Step 2
    xr = r_point.x
    
    # Step 3
    point_field = PrimeField.new(group.order)
    r = point_field.mod(xr)
    
    # Step 4, calculating the hash, was already performed by the caller.
    
    # Step 5    
    e = normalize_digest(digest, group.bit_length)
    
    # Step 6
    s = point_field.mod(point_field.inverse(k) * (e + r * private_key))
    
    if s.zero?
      # We need to go back to step 1, so the caller should generate another
      # random number k and try again.
      return nil
    end
    
    Signature.new [r, s]
  end
end