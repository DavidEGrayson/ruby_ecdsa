# encoding: ASCII-8BIT

require 'spec_helper'

describe ECDSA::Format::IntegerOctetString do
  describe '#encode' do
    it 'converts 0x1234 to "\x12\x34"' do
      expect(described_class.encode(0x1234, 2)).to eq "\x12\x34"
    end

    it 'converts 0x0004 to "\x00\x04"' do
      expect(described_class.encode(0x0004, 2)).to eq "\x00\x04"
    end

    it 'complains if the integer is too large' do
      expect { described_class.encode(0x10000, 2) }.to raise_error ArgumentError, 'Integer to encode is too large.'
    end

    it 'complains if the integer is negative' do
      expect { described_class.encode(-1, 2) }.to raise_error ArgumentError, 'Integer to encode is negative.'
    end
  end

  describe '#decode' do
    it 'converts "\x12\x34" to 0x1234' do
      expect(described_class.decode("\x12\x34")).to eq 0x1234
    end
  end
end
