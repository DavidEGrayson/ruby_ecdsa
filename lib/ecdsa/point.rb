# http://www.secg.org/collateral/sec1_final.pdf

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
        raise ArgumentError, "Invalid y: #{y.inspect}" if !y.is_a? Integer

        @x = x
        @y = y
      end
    end

    def coords
      [x, y]
    end

    def add_to_point(point)
      check_group! point

      # TODO: remove these assertions
      raise "point given (#{point.inspect}) does not belong to #{group.name}" if !group.include?(point)
      raise "point (#{inspect}) does not belong to #{group.name}" if !group.include?(self)

      # SEC1, section 2.2.1, rules 1 and 2
      return point if infinity?
      return self if point.infinity?

      # SEC1, section 2.2.1, rule 3
      return group.infinity_point if x == point.x && y == field.mod(-point.y)

      # SEC1, section 2.2.1, rule 4
      if x != point.x
        gamma = field.mod((point.y - y) * field.inverse(point.x - x))
        sum_x = field.mod(gamma * gamma - x - point.x)
        sum_y = field.mod(gamma * (x - sum_x) - y)
        return self.class.new(group, sum_x, sum_y)
      end

      # SEC2, section 2.2.1, rule 5
      if self == point
        return double
      end

      raise "Failed to add #{self.inspect} to #{point.inspect}: No addition rules matched."
    end

    def negate
      return self if infinity?
      self.class.new(group, x, field.mod(-y))
    end

    def double
      gamma = field.mod((3 * x * x + @group.param_a) * field.inverse(2 * y))
      new_x = field.mod(gamma * gamma - 2 * x)
      new_y = field.mod(gamma * (x - new_x) - y)
      self.class.new(group, new_x, new_y)
    end

    def multiply_by_scalar(i)
      result = group.infinity_point
      v = self
      while i > 0
        if (i % 2) == 1
          result = result.add_to_point(v)
        end
        v = v.double
        i >>= 1
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
      @infinity == true
    end

    def inspect
      if infinity?
        '#<%s: %s, infinity>' % [self.class, group.name]
      else
        '#<%s: %s, 0x%x, 0x%x>' % [self.class, group.name, x, y]
      end
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
