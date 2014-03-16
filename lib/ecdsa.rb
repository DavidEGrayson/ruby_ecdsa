require_relative 'ecdsa/group'
require_relative 'ecdsa/signature'
require_relative 'ecdsa/verify'
require_relative 'ecdsa/sign'

module ECDSA  
  def self.convert_digest_to_integer(digest)
    case digest
    when Integer then digest
    when String then convert_octet_string_to_bit_string(digest)
    else raise "Invalid digest: #{digest.inspect}"
    end
  end
  
  def self.leftmost_bits(n, bit_length)
    if n >= (1 << (8 * bit_length))
      raise 'Have not yet written code to handle this case'
    else
      n
    end
  end
  
  def self.normalize_digest(digest, bit_length)
    digest_num = convert_digest_to_integer(digest)
    leftmost_bits(digest_num, bit_length)
  end
  
  # SEC1, Section 2.3.2.
  # My interpretation of that section is that we treat the octet string as BIG endian.
  def self.convert_octet_string_to_bit_string(string)
    string.bytes.inject { |n, b| (n << 8) + b }
  end
end

class String
  def hex_inspect
    '"' + each_byte.collect { |b| '\x%02x' % b}.join + '"'
  end
end
