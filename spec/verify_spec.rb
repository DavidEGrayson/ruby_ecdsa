# encoding: ASCII-8BIT

require 'spec_helper'

describe ECDSA do
  describe 'bitcoin alert message' do
    # The data for this spec came from https://en.bitcoin.it/wiki/Protocol_specification#alert

    let :group do
      ECDSA::Group::Secp256k1
    end

    let :digest do
      "\xbf\x91\xfb\x0b\x4f\x63\x33\x77\x4a\x02\x2b\xd3\x07\x8e\xd6\xcc" \
      "\xd1\x76\xee\x31\xed\x4f\xb3\xf9\xaf\xce\xb7\x2a\x37\xe7\x87\x86"
    end

    let :signature_der_string do
      "\x30\x45" \
      "\x02\x21\x00" \
      "\x83\x89\xdf\x45\xf0\x70\x3f\x39\xec\x8c\x1c\xc4\x2c\x13\x81\x0f" \
      "\xfc\xae\x14\x99\x5b\xb6\x48\x34\x02\x19\xe3\x53\xb6\x3b\x53\xeb" \
      "\x02\x20" \
      "\x09\xec\x65\xe1\xc1\xaa\xee\xc1\xfd\x33\x4c\x6b\x68\x4b\xde\x2b" \
      "\x3f\x57\x30\x60\xd5\xb7\x0c\x3a\x46\x72\x33\x26\xe4\xe8\xa4\xf1"
    end

    let :signature do
      ECDSA::Format::SignatureDerString.decode(signature_der_string)
    end

    let :public_key_octet_string do
      "\x04" \
      "\xfc\x97\x02\x84\x78\x40\xaa\xf1\x95\xde\x84\x42\xeb\xec\xed\xf5" \
      "\xb0\x95\xcd\xbb\x9b\xc7\x16\xbd\xa9\x11\x09\x71\xb2\x8a\x49\xe0" \
      "\xea\xd8\x56\x4f\xf0\xdb\x22\x20\x9e\x03\x74\x78\x2c\x09\x3b\xb8" \
      "\x99\x69\x2d\x52\x4e\x9d\x6a\x69\x56\xe7\xc5\xec\xbc\xd6\x82\x84"
    end

    let :public_key do
      ECDSA::Format::PointOctetString.decode(public_key_octet_string, group)
    end

    it 'can verify the key is on the curve' do
      expect(group).to include public_key
    end

    it 'can verify the signature' do
      result = ECDSA.check_signature!(public_key, digest, signature)
      expect(result).to eq true
    end

    it 'can detect if the message is corrupted' do
      digest[2] = "\x44"
      result = ECDSA.valid_signature?(public_key, digest, signature)
      expect(result).to eq false
    end

  end
end
