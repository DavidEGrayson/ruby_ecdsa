require 'spec_helper'

describe ECDSA::Group do
  subject(:group) { ECDSA::Group::Secp128r2 }

  let(:partially_valid_point) do
    x = 0xa4ba08661ccb3c0a4f0be92e7d7b3efa
    y = group.solve_for_y(x).first
    group.new_point [x, y]
  end

  it '#inspect is nice' do
    expect(group.inspect).to eq '#<ECDSA::Group:secp128r2>'
  end

  it '#to_s is the same as inspect' do
    expect(group.to_s).to eq group.inspect
  end

  describe '#infinity' do
    it 'returns the infinity point' do
      expect(group.infinity).to be_infinity
    end

    it 'has an alias #infinity_point for backwards compatibility' do
      expect(group.method(:infinity_point)).to eq group.method(:infinity)
    end
  end

  describe '#new_point' do
    it 'when given :infinity, returns the infinity point' do
      expect(group.new_point(:infinity)).to eq group.infinity
    end

    it 'raises an exception when given something invalid' do
      expect { group.new_point(:smile) }.to raise_error ArgumentError,
        'Invalid point specifier :smile.'
    end
  end

  describe '#solve_for_y' do
    it 'when given the x of the generator point returns y and -y' do
      g = group.generator
      expect(group.solve_for_y(g.x)).to eq [g.y, group.field.mod(-g.y)].sort
    end
  end

  describe '#include?' do
    it 'returns true for the infinity point' do
      expect(group).to include group.infinity
    end

    it 'returns true for the generator' do
      expect(group).to include group.generator
    end

    it 'returns true for a point on the curve that is not a multiple of the generator' do
      expect(group).to include partially_valid_point
    end

    it 'returns false for a point not on the curve' do
      expect(group).to_not include group.new_point [44, 55]
    end

    it 'returns false for a point on the wrong group' do
      point = ECDSA::Group::Nistp521.new_point group.generator.coords
      expect(group).to_not include point
    end
  end

  describe '#partially_valid_public_key?' do
    it 'returns false for the infinity point' do
      expect(group).to_not be_partially_valid_public_key group.infinity
    end

    it 'returns true for the generator' do
      expect(group).to be_partially_valid_public_key group.generator
    end

    it 'returns true for a point on the curve that is not a multiple of the generator' do
      expect(group).to be_partially_valid_public_key partially_valid_point
    end

    it 'returns false for a point not on the curve' do
      expect(group).to_not be_partially_valid_public_key group.new_point [44, 55]
    end

    it 'returns false for a point on the wrong group' do
      point = ECDSA::Group::Nistp521.new_point group.generator.coords
      expect(group).to_not be_partially_valid_public_key point
    end
  end

  describe '#valid_public_key?' do
    it 'returns false for the infinity point' do
      expect(group).to_not be_valid_public_key group.infinity
    end

    it 'returns true for the generator' do
      expect(group).to be_valid_public_key group.generator
    end

    it 'returns false for a point on the curve that is not a multiple of the generator' do
      expect(group).to_not be_valid_public_key partially_valid_point
    end

    it 'returns false for a point not on the curve' do
      expect(group).to_not be_valid_public_key group.new_point [44, 55]
    end

    it 'returns false for a point on the wrong group' do
      point = ECDSA::Group::Nistp521.new_point group.generator.coords
      expect(group).to_not be_valid_public_key point
    end
  end

end

shared_examples_for 'group' do
  it 'generator point is on the curve' do
    expect(group.include?(group.generator)).to eq true
  end

  it 'has maybe the right order' do
    expect(group.generator.multiply_by_scalar(group.order)).to eq group.infinity
  end

  it '#name matches the string used to look it up' do
    expect(group.name).to eq name.downcase
  end
end

describe 'specific groups' do
  describe ECDSA::Group::Secp256k1 do
    subject(:group) { ECDSA::Group::Secp256k1 }

    it 'has a bit length of 256' do
      expect(group.bit_length).to eq 256
    end

    it 'has the right generator point' do
      expect(group.generator.coords).to eq [
        0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798,
        0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8,
      ]
    end
  end

  ECDSA::Group::NAMES.each do |name|
    group = ECDSA::Group.const_get(name)
    describe group do
      subject(:group) { group }
      let(:name) { name }
      it_behaves_like 'group'
    end
  end
end
