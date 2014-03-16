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
      expect(subject.inspect).to eq '<ECDSA::Group:secp256k1>'
    end
    
    it_behaves_like 'group'
  end
  
  describe ECDSA::Group::Nistp256 do
    subject { ECDSA::Group::Nistp256 }
    it_behaves_like 'group'
  end
  
  describe ECDSA::Group::Nistp384 do
    subject { ECDSA::Group::Nistp384 }
    it_behaves_like 'group'
  end

end