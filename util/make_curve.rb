preset_b = nil
preset_ax = nil
generator_factor = 1

# preset_b = 0x2ccd
# preset_ax = 0
# preset_ax = 0x6ef1
# generator_factor = 2

require 'ecdsa'
require 'prime'

def compute_order(point)
  n = 0
  p = point
  loop do
    p = p.add_to_point point
    n += 1
    return n if p == point
  end
end

def private_key(generator, point)
  n = 1
  p = generator
  loop do
    return n if p == point
    p = p.add_to_point generator
    n += 1
    return nil if n > 0xFFFF
  end
end

def count_points_on_curve(group)
  (0...group.field.prime).reduce(0) do |num, x|
    num + group.solve_for_y(x).size
  end
end

field = ECDSA::PrimeField.new(0xFF8F)

Davidp16d1 = group = ECDSA::Group.new(
  name: 'secp112r1',
  p: field.prime,
  a: field.prime - 3,
  b: preset_b || field.square(rand(field.prime)),

  g: [0, 0],
  n: 0,
  h: 1,
)

puts 'b: %#x' % group.param_b

y_axis_point_y = group.solve_for_y(0).first
abort 'No y for x = 0' if y_axis_point_y.nil?
y_axis_point = group.new_point [0, y_axis_point_y]

# Alpha point
ax = preset_ax || rand(field.prime)
puts 'ax: %#x' % ax
ay = group.solve_for_y(ax).first
abort 'No ay found' if ay.nil?
puts 'ay: %#x' % ay

alpha = group.new_point [ax, ay]

alpha_order = compute_order(alpha)

puts 'alpha order: %#x (%d)' % [alpha_order, alpha_order]
puts 'alpha order prime: %s' % Prime.prime?(alpha_order)

yap_private_key_sorta = private_key(alpha, y_axis_point)
puts 'yap private key sorta: %#x' % yap_private_key_sorta

raise 'bad generator factor' if !Prime.prime?(alpha_order / generator_factor)

generator = alpha.multiply_by_scalar(generator_factor)
order = compute_order(generator)

puts 'gx: %#x' % generator.x
puts 'gy: %#x' % generator.y

puts 'order: %#x (%d)' % [order, order]
puts 'order prime: %s' % Prime.prime?(order)

yap_private_key = private_key(generator, y_axis_point)
puts 'yap private key: %#x' % yap_private_key

point_count = count_points_on_curve(group)
puts 'points on curve: %#x' % point_count

cofactor, remainder = (point_count + 1).divmod order
puts 'cofactor: %d' % cofactor
raise 'bad' if remainder != 0
