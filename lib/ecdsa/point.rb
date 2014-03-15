module ECDSA
  class Point
    attr_reader :group
    
    attr_reader :x
    
    attr_reader :y
  
    def initialize(group, x, y)
      raise ArgumentError, "Invalid x: #{x.inspect}" if !x.is_a? Integer
      raise ArgumentError, "Invalid x: #{y.inspect}" if !y.is_a? Integer
    
      @group = group
      @x = x
      @y = y
    end
    
    def coords
      [x, y]
    end
  end
end