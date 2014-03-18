# encoding: ASCII-8BIT

require 'spec_helper'

describe ECDSA::Format::FieldElementOctetString do
  let(:field) { ECDSA::PrimeField.new(0x1EEF) }

  context 'for prime fields' do
    describe '#encode' do
      it 'defers to IntegerOctetString.encode' do
        expect(described_class.encode(0x1234, field)).to eq "\x12\x34"
      end

      it 'raises an error if you give it something not in the field' do
        expect { described_class.encode(0x1EEF, field) }.to raise_error(
          ArgumentError, 'Given element is not an element of the field.'
        )
      end
    end

    describe '#decode' do
      it 'defers to IntegerOctetString.decode' do
        expect(described_class.decode("\x07\x89", field)).to eq 0x0789
      end

      it 'raises an error if the integer in the string is too large' do
        expect { described_class.decode("\x1E\xEF", field) }.to raise_error(
          ECDSA::Format::DecodeError, 'Decoded integer is too large for field: 0x1eef >= 0x1eef.'
        )
      end
    end
  end

end
