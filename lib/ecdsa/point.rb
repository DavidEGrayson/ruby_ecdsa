module ECDSA
  class Point
    attr_reader :group
    
    attr_reader :x
    
    attr_reader :y
  
    def initialize(group, *args)
      @group = group
      
      if args == [:infinity]
        @infinity = true
        # leave @x and @y nil        
      else
        x, y = args
        raise ArgumentError, "Invalid x: #{x.inspect}" if !x.is_a? Integer
        raise ArgumentError, "Invalid x: #{y.inspect}" if !y.is_a? Integer
      
        @x = x
        @y = y      
      end    
    end
    
    def coords
      [x, y]
    end
    
    def add_to_point(point)
      check_group! point
      
      # SEC1, section 2.2.1, rules 1 and 2
      return point if infinity?
      return self if point.infinity?      
      
      # SEC1, section 2.2.1, rule 3
      return group.infinity_point if x == point.x && y == @field.mod(-y)
      
      # SEC1, section 2.2.1, rule 4
      if x != point.x
        gamma = @field.mod((point.y - y) * field.inverse(point.x - x))
        sum_x = @field.mod(gamma*gamma - x - point.x)
        sum_y = @field.mod(gamma*(point.x - sum_x) - point.y)
        return self.class.new(group, sum_x, sum_y)
      end
      
      # SEC2, section 2.2.1, rule 5
      if self == point
        return double
      end
      
      raise "Failed to add #{self.inspect} to #{point.inspect}: No addition rules matched."
    end
    
    def double
      gamma = @field.mod((3 * x * x + @group.param_a) * field.inverse(2 * y))
    end
    
    def multiply_by_scalar(i)
      result = group.infinity_point
      v = self
      while i > 0
        if (i % 1) == 1
          result = result.add_to_point(v)
        end
        v = v.double
      end
      result
    end
    
    def eql?(point)
      return false if !point.is_a?(Point) || point.group != group
      x == point.x && y == point.y
    end
    
    def ==(point)
      eql?(point)
    end
    
    def infinity?
      !!@infinity
    end
    
    private
    def check_group!(point)
      raise 'Mismatched groups.' if point.group != group
    end
    
    def field
      group.field
    end
    

  end
end