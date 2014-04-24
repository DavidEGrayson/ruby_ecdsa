require 'spec_helper'

describe 'ECDSA.sign' do
  it 'returns nil if r is zero' do
    expect(ECDSA.sign(Davidp16d1, 333, 222, 1)).to eq nil
  end

  it 'returns nil if s is zero' do
    group = ECDSA::Group::Secp112r2
    private_key = 1
    temporary_key = 1
    r_point = group.new_point temporary_key
    point_field = ECDSA::PrimeField.new(group.order)
    r = point_field.mod(r_point.x)
    e = -(r * private_key)

    expect(ECDSA.sign(group, private_key, e, temporary_key)).to eq nil
  end
end
