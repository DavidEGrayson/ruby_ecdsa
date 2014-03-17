# encoding: US-ASCII

require 'spec_helper'

describe ECDSA::Format::PointOctetString do
  let(:group) { ECDSA::Group::Secp112r1 }
  
  describe '#encode' do
    let(:converter) { ECDSA::Format::PointOctetString.method(:encode) }
  
    it 'converts infinity to "\x00"' do
      expect(converter.call(group.infinity_point)).to eq "\x00"
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
          lambda { |p| ECDSA::Format::PointOctetString.encode(p, compression: true) }
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
  
end