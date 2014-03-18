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

    # Computes n raised to the power m.
    # This algorithm uses the same idea as Point#multiply_by_scalar.
    def power(n, m)
      result = 1
      v = n
      while m > 0
        if (m % 2) == 1
          result = mod result * v
        end
        v = square v
        m >>= 1
      end
      result
    end

    # Computes n^2.
    def square(n)
      mod n * n
    end

    def square_roots(n)
      raise ArgumentError, "Not a member of the field: #{n}." if !include?(n)
      if (prime % 4) == 3
        square_roots_for_p_3_mod_4(n)
      else
        raise NotImplementedError, "Square root is only implemented in fields where the prime is equal to 3 mod 4."
      end
    end

    private

    # This is Algorithm 1 from http://math.stanford.edu/~jbooher/expos/sqr_qnr.pdf
    # The algorithm assumes that its input actually does have a square root.
    # To get around that, we double check the answer after running the algorithm to make
    # sure it works.
    def square_roots_for_p_3_mod_4(n)
      candidate = power n, (prime + 1) / 4
      return [] if square(candidate) != n
      return [candidate] if candidate.zero?
      return [candidate, mod(-candidate)].sort
    end
  end
end
