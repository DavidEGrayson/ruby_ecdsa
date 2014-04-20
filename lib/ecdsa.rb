require_relative 'ecdsa/group'
require_relative 'ecdsa/signature'
require_relative 'ecdsa/sign'
require_relative 'ecdsa/verify'
require_relative 'ecdsa/recover_public_key'
require_relative 'ecdsa/format'
require_relative 'ecdsa/version'

# The top-level module for the ECDSA gem.
module ECDSA
  # This method is NOT part of the public API of the ECDSA gem.
  def self.byte_length(integer)
    length = 0
    while integer > 0
      length += 1
      integer >>= 8
    end
    length
  end

  # This method is NOT part of the public API of the ECDSA gem.
  def self.bit_length(integer)
    length = 0
    while integer > 0
      length += 1
      integer >>= 1
    end
    length
  end

  # This method is NOT part of the public API of the ECDSA gem.
  def self.convert_digest_to_integer(digest)
    case digest
    when Integer then digest
    when String then Format::IntegerOctetString.decode(digest)
    else raise "Invalid digest: #{digest.inspect}"
    end
  end

  # This method is NOT part of the public API of the ECDSA gem.
  def self.leftmost_bits(n, bit_length)
    if n >= (1 << bit_length)
      # TODO: implement this
      raise NotImplementedError, 'Have not yet written code to handle this case'
    else
      n
    end
  end

  # This method is NOT part of the public API of the ECDSA gem.
  def self.normalize_digest(digest, bit_length)
    digest_num = convert_digest_to_integer(digest)
    leftmost_bits(digest_num, bit_length)
  end
end
