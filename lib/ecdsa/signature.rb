module ECDSA
  class Signature
    attr_reader :r
    attr_reader :s

    def initialize(r, s)
      @r, @s = r, s
      r.is_a?(Integer) or raise ArgumentError, 'r is not an integer.'
      s.is_a?(Integer) or raise ArgumentError, 's is not an integer.'
    end

    def components
      [r, s]
    end
  end
end
