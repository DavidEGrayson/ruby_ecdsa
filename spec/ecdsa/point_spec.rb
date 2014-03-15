require 'spec_helper'

describe ECDSA::Point do
  let(:group) do
    ECDSA::Group::Secp256k1
  end
  
  describe 'multiplty_by_scalar' do
    it 'does not give infinity when we multiply the generator of secp256k1 by a number less than the order' do
      # this test was added to fix a particular bug
      #k = 0xb130b7c8_b8a059d4_58ab248f_e9582ad8_77b6b3b5_f1a83cea_669558ab_eddb1692
      k = 2
      expect(k).to be < group.order
      point = group.generator.multiply_by_scalar(k)
      expect(point).to_not be_infinity
    end
  end
  
  describe 'add_to_point' do
    context 'when adding point + infinity' do
      it 'returns the point' do
        expect(group.generator.add_to_point(group.infinity_point)).to eq group.generator
      end
    end

    context 'when adding infinity + point' do
      it 'returns the point' do
        expect(group.infinity_point.add_to_point(group.generator)).to eq group.generator
      end
    end
  end
  
  describe 'double' do
    it 'can double the generator of secp256k1' do
      point = group.generator.double
      expect(point).to_not be_infinity
    end
  end
  
  describe '#inspect' do
    it 'is nice' do
      expect(group.generator.inspect).to eq "<ECDSA::Point: secp256k1, " \
        "0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798, " \
        "0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8>"
    end
  end
end