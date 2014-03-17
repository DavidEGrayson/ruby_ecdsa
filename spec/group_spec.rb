require 'spec_helper'
require 'prime'

shared_examples_for 'group' do
  it 'generator point is on the curve' do
    expect(subject.include?(subject.generator)).to eq true
  end
    
  it 'has maybe the right order' do
    expect(subject.generator.multiply_by_scalar(subject.order)).to eq subject.infinity_point
  end
end

describe ECDSA::Group do
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
    
    it 'has a nice #inspect' do
      expect(subject.inspect).to eq '#<ECDSA::Group:secp256k1>'
    end
    
    it 'has a #to_s that is the same as inspect' do
      expect(subject.to_s).to eq subject.inspect
    end
  end
  
  groups = [
    ECDSA::Group::Secp112r1,
    ECDSA::Group::Secp112r2,
    ECDSA::Group::Secp128r1,
    ECDSA::Group::Secp128r2,
    ECDSA::Group::Secp160k1,
    ECDSA::Group::Secp160r1,
    ECDSA::Group::Secp160r2,
    ECDSA::Group::Secp192k1,
    ECDSA::Group::Secp192r1,
    ECDSA::Group::Secp224k1,
    ECDSA::Group::Secp224r1,
    ECDSA::Group::Secp256k1,
    ECDSA::Group::Secp256r1,
    ECDSA::Group::Secp384r1,
    ECDSA::Group::Secp521r1,
    ECDSA::Group::Nistp192,
    ECDSA::Group::Nistp224,
    ECDSA::Group::Nistp256,
    ECDSA::Group::Nistp384,
    ECDSA::Group::Nistp521,
  ]
  
  # TODO: replace above list with strings and make the strings are consistent with group.name
  
  groups.each do |group|
    describe group do
      subject { group }
      it_behaves_like 'group'
    end
  end
end