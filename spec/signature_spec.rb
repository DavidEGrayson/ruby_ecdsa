require 'spec_helper'

describe ECDSA::Signature do

  context 'when created from DER' do
    let(:signature_der) do
      "\x30\x45" \
      "\x02\x21\x00" \
      "\x83\x89\xdf\x45\xf0\x70\x3f\x39\xec\x8c\x1c\xc4\x2c\x13\x81\x0f" \
      "\xfc\xae\x14\x99\x5b\xb6\x48\x34\x02\x19\xe3\x53\xb6\x3b\x53\xeb" \
      "\x02\x20" \
      "\x09\xec\x65\xe1\xc1\xaa\xee\xc1\xfd\x33\x4c\x6b\x68\x4b\xde\x2b" \
      "\x3f\x57\x30\x60\xd5\xb7\x0c\x3a\x46\x72\x33\x26\xe4\xe8\xa4\xf1"
    end
    
    let(:signature) { described_class.new(signature_der) }
  
    it 'has the right r value' do
      expect(signature.r).to eq 0x8389df45f0703f39ec8c1cc42c13810ffcae14995bb648340219e353b63b53eb
    end
    
    it 'has the right s value' do
      expect(signature.s).to eq 0x9ec65e1c1aaeec1fd334c6b684bde2b3f573060d5b70c3a46723326e4e8a4f1
    end
  
  end  
end