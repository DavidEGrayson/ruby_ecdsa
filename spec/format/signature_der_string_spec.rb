# encoding: ASCII-8BIT

require 'spec_helper'

describe ECDSA::Format::SignatureDerString do

  let(:signature_der) do
    "\x30\x45" \
    "\x02\x21\x00" \
    "\x83\x89\xdf\x45\xf0\x70\x3f\x39\xec\x8c\x1c\xc4\x2c\x13\x81\x0f" \
    "\xfc\xae\x14\x99\x5b\xb6\x48\x34\x02\x19\xe3\x53\xb6\x3b\x53\xeb" \
    "\x02\x20" \
    "\x09\xec\x65\xe1\xc1\xaa\xee\xc1\xfd\x33\x4c\x6b\x68\x4b\xde\x2b" \
    "\x3f\x57\x30\x60\xd5\xb7\x0c\x3a\x46\x72\x33\x26\xe4\xe8\xa4\xf1"
  end

  let(:r) { 0x8389df45f0703f39ec8c1cc42c13810ffcae14995bb648340219e353b63b53eb }
  let(:s) { 0x9ec65e1c1aaeec1fd334c6b684bde2b3f573060d5b70c3a46723326e4e8a4f1 }

  describe '#decode' do
    let(:signature) { described_class.decode(signature_der) }

    it 'retrieves the right r value' do
      expect(signature.r).to eq r
    end

    it 'retrieves the right s value' do
      expect(signature.s).to eq s
    end
  end

  describe '#encode' do
    it 'can encode' do
      str = described_class.encode(ECDSA::Signature.new(r, s))
      expect(str).to eq signature_der
    end
  end
end
