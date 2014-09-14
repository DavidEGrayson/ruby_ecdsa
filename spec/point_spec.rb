require 'spec_helper'

describe ECDSA::Point do
  let(:group) do
    ECDSA::Group::Secp256k1
  end

  describe '#multiply_by_scalar' do
    it 'does not give infinity when we multiply the generator of secp256k1 by a number less than the order' do
      # this test was added to fix a particular bug
      k = 2
      expect(k).to be < group.order
      point = group.generator.multiply_by_scalar(k)
      expect(point).to_not be_infinity
    end

    it 'complains if the argument is not an integer' do
      expect { group.generator.multiply_by_scalar(1.1) }.to raise_error ArgumentError, 'Scalar is not an integer.'
    end

    it 'complains if the argument is negative' do
      expect { group.generator.multiply_by_scalar(-3) }.to raise_error ArgumentError, 'Scalar is negative.'
    end

    it 'is aliased to :*' do
      expect(group.generator.method(:*)).to eq group.generator.method(:multiply_by_scalar)
    end
  end

  describe '#coords' do
    it 'returns [nil, nil] for infinity' do
      expect(group.infinity.coords).to eq [nil, nil]
    end

    it 'returns x and y' do
      expect(group.generator.coords).to eq [
        0x79BE667E_F9DCBBAC_55A06295_CE870B07_029BFCDB_2DCE28D9_59F2815B_16F81798,
        0x483ADA77_26A3C465_5DA4FBFC_0E1108A8_FD17B448_A6855419_9C47D08F_FB10D4B8]
    end
  end

  describe '#double' do
    it 'returns infinity for infinity' do
      expect(group.infinity.double).to eq group.infinity
    end

    it 'can double the generator' do
      expect(group.generator.double).to_not be_infinity
    end
  end

  describe '#add_to_point' do
    context 'when adding point + infinity' do
      it 'returns the point' do
        expect(group.generator.add_to_point(group.infinity)).to eq group.generator
      end
    end

    context 'when adding infinity + point' do
      it 'returns the point' do
        expect(group.infinity.add_to_point(group.generator)).to eq group.generator
      end
    end

    context 'when adding the generator to itself' do
      it 'returns the double' do
        expect(group.generator.add_to_point(group.generator)).to eq group.generator.double
      end
    end

    it 'is aliased to :+' do
      expect(group.generator.method(:+)).to eq group.generator.method(:add_to_point)
    end
  end

  describe '#negate' do
    it 'returns infinity for infinity' do
      expect(group.infinity.negate).to eq group.infinity
    end

    it 'returns a point with same x coordinate but negated y coordinate' do
      n = group.generator.negate
      expect(n.x).to eq group.generator.x
      expect(n.y).to eq group.field.mod(-group.generator.y)
    end
  end

  describe '#inspect' do
    it 'shows the coordinates if the point has them' do
      expect(group.generator.inspect).to eq '#<ECDSA::Point: secp256k1, ' \
        '0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798, ' \
        '0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8>'
    end

    it 'shows infinity if the point is infinity' do
      expect(group.infinity.inspect).to eq '#<ECDSA::Point: secp256k1, infinity>'
    end
  end

  shared_examples_for 'point comparator' do |method|
    let(:p1) { group.new_point [4, 5] }

    it 'returns true for points with the same coordinates' do
      p2 = group.new_point [4, 5]
      expect(method.call(p1, p2)).to eq true
    end

    it 'returns false for points with different x coordinates' do
      p2 = group.new_point [5, 5]
      expect(method.call(p1, p2)).to eq false
    end

    it 'returns false for points with different y coordinates' do
      p2 = group.new_point [4, 4]
      expect(method.call(p1, p2)).to eq false
    end

    it 'returns false for non-points' do
      expect(method.call(p1, 44)).to eq false
    end

    it 'returns false for points on another curve' do
      p2 = ECDSA::Group::Secp112r2.new_point [4, 5]
      expect(method.call(p1, p2)).to eq false
    end
  end

  describe '#eql?' do
    it_behaves_like 'point comparator', ->(p, q) { p.eql? q }
  end

  describe '#==' do
    it_behaves_like 'point comparator', ->(p, q) { p == q }
  end

  describe '#hash' do
    # There is a small chance these tests will fail due to a hash collision.
    it_behaves_like 'point comparator', ->(p, q) { p.hash == q.hash }
  end
end
