# encoding: US-ASCII

require 'spec_helper'

describe ECDSA::Format::FieldElementOctetString do
  let(:field) { ECDSA::PrimeField.new(0x1EEF) }

  context 'for prime fields' do
    describe '#encode' do
      it 'defers to IntegerOctetString.encode' do
        expect(described_class.encode(0x1234, field)).to eq "\x12\x34"
      end
      
      it 'raises an error if you give it something not in the field' do
        expect{ described_class.encode(0x1EEF, field) }.to raise_error ArgumentError, 'Given element is not an element of the field.'
      end      
    end
  end  
  
end