require_relative 'prime_field'
require_relative 'point'

module ECDSA
  class Group
    attr_reader :generator
    
    attr_reader :order
    
    attr_reader :param_a
    
    attr_reader :field
    
    # These parameters are defined in http://www.secg.org/collateral/sec2_final.pdf
    #
    # - +p+: A prime number that defines the field used.  The field will be F_p.
    # - +a+: The a parameter in the curve equation (y^2 = x^3 + ax + b).
    # - +b+: The b parameter in the curve equation.
    # - +g+: The base point as an octet string.
    # - +n+: The order of g.
    # - +h+: The cofactor.
    def initialize(opts)
      @opts = opts
      
      @field = PrimeField.new(opts[:p])
      @param_a = opts[:a]
      @param_b = opts[:b]
      @generator = new_point(@opts[:g])
      @order = opts[:n]
      @cofactor = opts[:h]
      
      @field.include?(@param_a) or raise ArgumentError, 'Invalid a.'
      @field.include?(@param_b) or raise ArgumentError, 'Invalid b.'
    end
    
    # TODO: allow generating points from:
    #  compressed octet strings
    #  [x, y]  (public key numbers)
    #  a       (private key number)
    def new_point(octet_string)
      x, y = decode_octet_string(octet_string)
      @generator = Point.new(self, x, y)
    end
    
    def infinity_point
      @infinity_point ||= Point.new(self, :infinity)
    end

    # The number of bits that it takes to represent a member of the field.
    # Log base 2 of the prime p, rounded up.    
    def bit_length
      @bit_length ||= compute_bit_length(@field.prime)
    end
    
    # Verify that the point is a solution to the curve's defining equation.
    def include?(point)
      raise 'Group mismatch.' if point.group != self
      @field.mod(point.y * point.y) == @field.mod(point.x * point.x * point.x + @param_a * point.x + @param_b)
    end
    
    private
    def decode_octet_string(octet_string)
      octet_string = octet_string.force_encoding('BINARY')
      first_byte = octet_string[0].ord
      if first_byte == 0x04
        if bit_length % 8 != 0
          raise 'Don\'t know how to handle bit lengths that are not a multiple of 8 (1 byte).'
        end
        
        byte_size = bit_length / 8
        expected_size = 1 + 2 * byte_size
        if octet_string.size != expected_size
          raise ArgumentError, "Bad string size.  Expected #{expected_size}, got #{octet_string.size}."
        end
        x_string = octet_string[1, byte_size]
        y_string = octet_string[1 + byte_size, byte_size]
        #x = ECDSA.convert_octet_string_to_bit_string(x_string)
        #y = ECDSA.convert_octet_string_to_bit_string(y_string)
        x = x_string.bytes.inject { |n, b| (n << 8) + b }
        y = y_string.bytes.inject { |n, b| (n << 8) + b }
        [x, y]
      else
        raise 'Cannot handle octet strings starting with 0x%02x' % first_byte
      end
    end
    
    def compute_bit_length(num)
      bit_length = 0
      while num > 0
        bit_length += 1
        num >>= 1
      end
      bit_length
    end
  
    public
    autoload :Secp256k1, 'ecdsa/group/secp256k1'
  end
end