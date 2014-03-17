require 'spec_helper'

describe ECDSA do
  describe '.byte_length' do
    it 'returns 0 for 0' do
      expect(ECDSA.byte_length(0)).to eq 0
    end
    
    it 'returns 1 for 254' do
      expect(ECDSA.byte_length(254)).to eq 1
    end
    
    it 'returns 2 for 256' do
      expect(ECDSA.byte_length(256)).to eq 2
    end
  end
  
  describe '.bit_length' do
    it 'returns 0 for 0' do
      expect(ECDSA.bit_length(0)).to eq 0
    end
    
    it 'returns 8 for 254' do
      expect(ECDSA.bit_length(254)).to eq 8
    end
    
    it 'returns 16 for 0x8000' do
      expect(ECDSA.bit_length(0x8000)).to eq 16
    end
  end
end