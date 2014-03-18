require 'spec_helper'
require 'prime'

shared_examples_for 'group' do
  it 'generator point is on the curve' do
    expect(subject.include?(subject.generator)).to eq true
  end

  it 'has maybe the right order' do
    expect(subject.generator.multiply_by_scalar(subject.order)).to eq subject.infinity_point
  end

  it '#name matches the string used to look it up' do
    expect(subject.name).to eq name.downcase
  end
end

describe ECDSA::Group do
  subject { ECDSA::Group::Secp256k1 }

  it '#inspect is nice' do
    expect(subject.inspect).to eq '#<ECDSA::Group:secp256k1>'
  end

  it '#to_s is the same as inspect' do
    expect(subject.to_s).to eq subject.inspect
  end

  describe '#infinity_point' do
    it 'returns the infinity point' do
      expect(subject.infinity_point).to be_infinity
    end
  end

  describe '#new_point' do
    it 'when given :infinity, returns the infinity point' do
      expect(subject.new_point(:infinity)).to eq subject.infinity_point
    end
  end

  describe '#solve_for_y' do
    it 'when given the x of the generator point returns y and -y' do
      g = subject.generator
      expect(subject.solve_for_y(g.x)).to eq [g.y, subject.field.mod(-g.y)].sort
    end
  end
end

describe "specific groups" do
  describe ECDSA::Group::Secp256k1 do
    subject { ECDSA::Group::Secp256k1 }

    it 'has a bit length of 256' do
      expect(subject.bit_length).to eq 256
    end

    it 'has the right generator point' do
      expect(subject.generator.coords).to eq [
        0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798,
        0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8,
      ]
    end
  end

  ECDSA::Group::NAMES.each do |name|
    group = ECDSA::Group.const_get(name)
    describe group do
      subject { group }
      let(:name) { name }
      it_behaves_like 'group'
    end
  end
end
