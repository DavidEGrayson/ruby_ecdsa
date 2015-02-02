require_relative 'ecdsa/group'
require_relative 'ecdsa/signature'
require_relative 'ecdsa/sign'
require_relative 'ecdsa/verify'
require_relative 'ecdsa/recover_public_key'
require_relative 'ecdsa/format'
require_relative 'ecdsa/version'

# TODO: fix the broken URLs we have for SEC1 and SEC2 all over the code base

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
  def self.normalize_digest(digest, bit_length)
    if digest.is_a?(String)
      digest = digest.dup.force_encoding('BINARY')
      digest_bit_length = digest.size * 8
      num = Format::IntegerOctetString.decode(digest)

      if digest_bit_length <= bit_length
        num
      else
        num >> (digest_bit_length - bit_length)
      end
    elsif digest.is_a?(Integer)
      digest
    else
      raise ArgumentError, 'Digest must be a string or integer.'
    end
  end
end
