module ECDSA
  # Instances of this class represent a point on an elliptic curve.
  # The instances hold their `x` and `y` coordinates along with a reference to
  # the {Group} (curve) they belong to.
  #
  # An instance of this class can also represent the infinity point
  # (the additive identity of the group), in which case `x` and `y` are `nil`.
  #
  # Note: These {Point} objects are not checked when they are created so they
  # might not actually be on the curve.  You can use {Group#include?} to see if
  # they are on the curve.
  class Point
    # @return {Group} the curve that the point is on.
    attr_reader :group

    # @return (Integer or nil) the x coordinate, or nil for the infinity point.
    attr_reader :x

    # @return (Integer or nil) the y coordinate, or nil for the infinity point.
    attr_reader :y

    # Creates a new instance of {Point}.
    # This method is NOT part of the public interface of the ECDSA gem.
    # You should call {Group#new_point} instead of calling this directly.
    #
    # @param group (Group)
    # @param args Either the x and y coordinates as integers, or just
    #  `:infinity` to create the infinity point.
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

    # Returns an array of the coordinates, with `x` first and `y` second.
    #
    # @return (Array)
    def coords
      [x, y]
    end

    # Adds this point to another point on the same curve using the standard
    # rules for point addition defined in section 2.2.1 of
    # [SEC1](http://www.secg.org/collateral/sec1_final.pdf).
    #
    # @param other (Point)
    # @return The sum of the two points.
    def add_to_point(other)
      check_group! other

      # Assertions:
      # raise "point given (#{point.inspect}) does not belong to #{group.name}" if !group.include?(point)
      # raise "point (#{inspect}) does not belong to #{group.name}" if !group.include?(self)

      # Rules 1 and 2
      return other if infinity?
      return self if other.infinity?

      # Rule 3
      return group.infinity if x == other.x && y == field.mod(-other.y)

      # Rule 4
      if x != other.x
        gamma = field.mod((other.y - y) * field.inverse(other.x - x))
        sum_x = field.mod(gamma * gamma - x - other.x)
        sum_y = field.mod(gamma * (x - sum_x) - y)
        return self.class.new(group, sum_x, sum_y)
      end

      # Rule 5
      return double if self == other

      raise "Failed to add #{inspect} to #{other.inspect}: No addition rules matched."
    end

    # (see #add_to_point)
    alias_method :+, :add_to_point

    # Returns the additive inverse of the point.
    #
    # @return (Point)
    def negate
      return self if infinity?
      self.class.new(group, x, field.mod(-y))
    end

    # Returns the point added to itself.
    #
    # This algorithm is defined in
    # [SEC1](http://www.secg.org/collateral/sec1_final.pdf), Section 2.2.1,
    # Rule 5.
    #
    # @return (Point)
    def double
      return self if infinity?
      gamma = field.mod((3 * x * x + @group.param_a) * field.inverse(2 * y))
      new_x = field.mod(gamma * gamma - 2 * x)
      new_y = field.mod(gamma * (x - new_x) - y)
      self.class.new(group, new_x, new_y)
    end

    # Returns the point multiplied by a non-negative integer.
    #
    # @param i (Integer)
    # @return (Point)
    def multiply_by_scalar(i)
      raise ArgumentError, 'Scalar is not an integer.' if !i.is_a?(Integer)
      raise ArgumentError, 'Scalar is negative.' if i < 0
      result = group.infinity
      v = self
      while i > 0
        result = result.add_to_point(v) if i.odd?
        v = v.double
        i >>= 1
      end
      result
    end

    # (see #multiply_by_scalar)
    alias_method :*, :multiply_by_scalar

    # Compares this point to another.
    #
    # @return (true or false) true if the points are equal
    def eql?(other)
      return false if !other.is_a?(Point) || other.group != group
      x == other.x && y == other.y
    end

    # Compares this point to another.
    #
    # @return (true or false) true if the points are equal
    def ==(other)
      eql?(other)
    end

    # Returns a hash for this point so it can be stored in hash tables
    # with the expected behavior.  Two points that have the same coordinates
    # and are on the same curve are equal, so they should not get separate
    # spots in a hash table.
    #
    # @return (Integer)
    def hash
      [group, x, y].hash
    end

    # Returns true if this instance represents the infinity point (the additive
    # identity of the group).
    #
    # @return (true or false)
    def infinity?
      @infinity == true
    end

    # Returns a string showing the value of the point which is useful for
    # debugging.
    #
    # @return (String)
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
