module ECDSA
  # Instances of this class represents ECDSA signatures,
  # which are simply a pair of integers named `r` and `s`.
  class Signature
    # @return (Integer)
    attr_reader :r

    # @return (Integer)
    attr_reader :s

    # @param r (Integer) the value of r.
    # @param s (Integer) the value of s.
    def initialize(r, s)
      @r, @s = r, s
      r.is_a?(Integer) or raise ArgumentError, 'r is not an integer.'
      s.is_a?(Integer) or raise ArgumentError, 's is not an integer.'
    end

    # Returns an array containing `r` first and `s` second.
    # @return (Array)
    def components
      [r, s]
    end
  end
end
