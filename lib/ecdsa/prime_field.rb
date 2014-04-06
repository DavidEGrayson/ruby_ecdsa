module ECDSA
  # Instances of this class represent a field where the elements are non-negative
  # integers less than a prime *p*.
  #
  # To add two elements of the field:
  #
  # ```ruby
  # sum = field.mod(a + b)
  # ```
  #
  # To multiply two elements of the field:
  #
  # ```ruby
  # product = field.mod(a * b)
  # ```
  class PrimeField
    # @return (Integer) the prime number that the field is based on.
    attr_reader :prime

    def initialize(prime)
      raise ArgumentError, "Invalid prime #{prime.inspect}" if !prime.is_a?(Integer)
      @prime = prime
    end

    # Returns true if the given object is an integer and a member of the field.
    # @param e (Object)
    # @return (true or false)
    def include?(e)
      e.is_a?(Integer) && e >= 0 && e < prime
    end

    # Calculates the remainder of `n` after being divided by the field's prime.
    # @param n (Integer)
    # @return (Integer)
    def mod(n)
      n % prime
    end

    # Computes the multiplicative inverse of a field element using the
    # [Extended Euclidean Algorithm](http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm).
    #
    # @param n (Integer)
    # @return (Integer) integer `inv` such that `(inv * num) % prime` is one.
    def inverse(n)
      raise ArgumentError, '0 has no multiplicative inverse.' if n.zero?

      # For every i, we make sure that num * s[i] + prime * t[i] = r[i].
      # Eventually r[i] will equal 1 because gcd(num, prime) is always 1.
      # At that point, s[i] is the multiplicative inverse of num in the field.

      remainders = [n, prime]
      s = [1, 0]
      t = [0, 1]
      arrays = [remainders, s, t]
      while remainders.last > 0
        quotient = remainders[-2] / remainders[-1]
        arrays.each do |array|
          array << array[-2] - quotient * array[-1]
        end
      end

      raise 'Inversion bug: remainder is not 1.' if remainders[-2] != 1
      mod s[-2]
    end

    # Computes `n` raised to the power `m`.
    # This algorithm uses the same idea as {Point#multiply_by_scalar}.
    #
    # @param n (Integer) the base
    # @param m (Integer) the exponent
    # @return (Integer)
    def power(n, m)
      result = 1
      v = n
      while m > 0
        result = mod result * v if m.odd?
        v = square v
        m >>= 1
      end
      result
    end

    # Computes `n` multiplied by itself.
    # @param n (Integer)
    # @return (Integer)
    def square(n)
      mod n * n
    end

    # Finds all possible square roots of the given field element.
    # Currently this method only supports fields where the prime is one
    # less than a multiple of four.
    #
    # @param n (Integer)
    # @return (Array) A sorted array of numbers whose square is equal to `n`.
    def square_roots(n)
      raise ArgumentError, "Not a member of the field: #{n}." if !include?(n)
      if (prime % 4) == 3
        square_roots_for_p_3_mod_4(n)
      else
        raise NotImplementedError, 'Square root is only implemented in fields where the prime is equal to 3 mod 4.'
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
      [candidate, mod(-candidate)].uniq.sort
    end
  end
end
