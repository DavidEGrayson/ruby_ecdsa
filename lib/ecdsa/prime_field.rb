module ECDSA
  class PrimeField
    attr_reader :prime
  
    def initialize(prime)
      raise ArgumentError, "Invalid prime #{prime.inspect}" if !prime.is_a?(Integer)
      @prime = prime
    end
    
    def include?(e)
      e.is_a?(Integer) && e >= 0 && e < prime
    end
    
    def mod(num)
      num % prime
    end
    
    # http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
    def inverse(num)
      raise ArgumentError, '0 has no multiplicative inverse.' if num.zero?
      
      # For every i, we make sure that num * s[i] + prime * t[i] = r[i].
      # Eventually r[i] will equal 1 because gcd(num, prime) is always 1.
      # At that point, s[i] is the multiplicative inverse of num in the field.
      
      remainders = [num, prime]
      s = [1, 0]
      t = [0, 1]
      arrays = [remainders, s, t]
      while remainders.last > 0
        quotient = remainders[-2] / remainders[-1]
        arrays.each do |array|
          array << array[-2] - quotient * array[-1]
        end
      end

      raise 'Inversion bug: remainder is not than 1.' if remainders[-2] != 1
      mod s[-2]
    end
  end
end