# encoding: ASCII-8BIT

require 'spec_helper'

describe ECDSA::Format::PointOctetString do
  let(:group) { ECDSA::Group::Secp112r1 }

  describe '#encode' do
    let(:converter) { ECDSA::Format::PointOctetString.method(:encode) }

    it 'converts infinity to "\x00"' do
      expect(converter.call(group.infinity)).to eq "\x00"
    end

    context 'for a prime field' do

      context 'without point compression (default)' do
        it 'converts a non-infinity point' do
          expect(converter.call(group.generator)).to eq "\x04" \
            "\x09\x48\x72\x39\x99\x5A\x5E\xE7\x6B\x55\xF9\xC2\xF0\x98" \
            "\xA8\x9C\xE5\xAF\x87\x24\xC0\xA2\x3E\x0E\x0F\xF7\x75\x00"
        end
      end

      context 'with point compression' do
        let(:converter) do
          ->(p) { ECDSA::Format::PointOctetString.encode(p, compression: true) }
        end

        context 'with an even Y' do
          let(:point) { group.generator }

          it 'starts with 0x02' do
            expect(converter.call(point)).to eq "\x02\x09\x48\x72\x39\x99\x5A\x5E\xE7\x6B\x55\xF9\xC2\xF0\x98"
          end
        end

        context 'with an odd Y' do
          let(:point) { group.generator.multiply_by_scalar(3) }

          it 'starts with 0x03' do
            expect(converter.call(point)).to eq "\x03\xCF\xC1\xE3\x44\x7F\xC3\x3E\x5C\x2A\x7D\x2B\xF7\x12\x98"
          end
        end

      end

    end
  end

  describe '#decode' do
    let(:converter) do
      ->(p) { ECDSA::Format::PointOctetString.decode(p, group) }
    end

    it 'raises an error for the empty string' do
      expect { converter.call('') }.to raise_error ECDSA::Format::DecodeError,
        'Point octet string is empty.'
    end

    it 'decodes "\x00" to infinity' do
      expect(converter.call("\x00")).to eq group.infinity
    end

    it 'raises an error if the start byte is not recognized' do
      expect { converter.call("\x12") }.to raise_error ECDSA::Format::DecodeError,
        'Unrecognized start byte for point octet string: 0x12'
    end

    it 'raises an error if the string starts with 0x00 but is more than 1 byte' do
      expect { converter.call("\x00\x00") }.to raise_error ECDSA::Format::DecodeError,
        'Expected point octet string to be length 1 but it was 2.'
    end

    [2, 3].each do |start_byte|
      it "raises an error if string starts with #{start_byte} but is the wrong length" do
        expect { converter.call(start_byte.chr + '...') }.to raise_error ECDSA::Format::DecodeError,
          'Expected point octet string to be length 15 but it was 4.'
      end
    end

    it 'raises an error if string starts with 4 but is the wrong length' do
      expect { converter.call("\x04...") }.to raise_error ECDSA::Format::DecodeError,
        'Expected point octet string to be length 29 but it was 4.'
    end

    it 'can decode an uncompressed point' do
      str = "\x04" \
            "\x09\x48\x72\x39\x99\x5A\x5E\xE7\x6B\x55\xF9\xC2\xF0\x98" \
            "\xA8\x9C\xE5\xAF\x87\x24\xC0\xA2\x3E\x0E\x0F\xF7\x75\x00"

      expect(converter.call(str)).to eq group.generator
    end

    it 'can decode a compressed point starting with 0x02' do
      str = "\x02" \
            "\x09\x48\x72\x39\x99\x5A\x5E\xE7\x6B\x55\xF9\xC2\xF0\x98"

      expect(converter.call(str)).to eq group.generator
    end

    it 'can decode a compressed point starting with 0x03' do
      str = "\x03" \
            "\x09\x48\x72\x39\x99\x5A\x5E\xE7\x6B\x55\xF9\xC2\xF0\x98"

      expect(converter.call(str)).to eq group.generator.negate
    end

    it 'raises an error if the point is not actually on the curve' do
      str = "\x04" \
        "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08" \
        "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x09"

      expect { converter.call(str) }.to raise_error ECDSA::Format::DecodeError,
        'Decoded point does not satisfy curve equation: #<ECDSA::Point: secp112r1, 0x8, 0x9>.'
    end

    it 'raises an error if it cannot solve for Y' do
      str = "\x03" \
            "\x09\x48\x72\x39\x99\x5A\x5E\xE7\x6B\x55\xF9\xC2\xF0\x99"

      expect { converter.call(str) }.to raise_error ECDSA::Format::DecodeError,
        'Could not solve for y.'
    end

    it 'can decode a string with the wrong encoding set' do
      str = "\x04" \
            "\x09\x48\x72\x39\x99\x5A\x5E\xE7\x6B\x55\xF9\xC2\xF0\x98" \
            "\xA8\x9C\xE5\xAF\x87\x24\xC0\xA2\x3E\x0E\x0F\xF7\x75\x00"
      str.force_encoding('UTF-8')
      expect(converter.call(str)).to eq group.generator
    end

  end
end
