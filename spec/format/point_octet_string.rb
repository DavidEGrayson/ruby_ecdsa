require 'spec_helper'

describe ECDSA::Format::PointOctetString do
  let(:group) { ECDSA::Group::Secp112r1 }
  
  before do
    extend ConvertToMatcherContext
  end
  
  describe '#encode' do
    before do
      @converter = ECDSA::Format::PointOctetString.method(:encode)
    end
  
    it 'converts infinity to "\x00"' do
      expect(group.infinity_point).to convert_to "\x00"
    end
  end
  
end