require 'spec_helper'

describe ECDSA::Signature do
  let(:signature) { described_class.new(44, 55) }

  it 'has the right r value' do
    expect(signature.r).to eq 44
  end

  it 'has the right s value' do
    expect(signature.s).to eq 55
  end

  it 'has the right components' do
    expect(signature.components).to eq [44, 55]
  end
end
