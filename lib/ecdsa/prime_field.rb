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
  end
end