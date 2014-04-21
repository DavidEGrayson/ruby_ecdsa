require 'spec_helper'

describe 'ECDSA.recover_public_key' do
  # The data for this spec came from https://en.bitcoin.it/wiki/Protocol_specification#alert

  let :group do
    ECDSA::Group::Secp256k1
  end

  let :public_key do
    group.new_point [
      0xfc9702847840aaf195de8442ebecedf5b095cdbb9bc716bda9110971b28a49e0,
      0xead8564ff0db22209e0374782c093bb899692d524e9d6a6956e7c5ecbcd68284,
    ]
  end

  let :digest do
    "\xbf\x91\xfb\x0b\x4f\x63\x33\x77\x4a\x02\x2b\xd3\x07\x8e\xd6\xcc" \
    "\xd1\x76\xee\x31\xed\x4f\xb3\xf9\xaf\xce\xb7\x2a\x37\xe7\x87\x86"
  end

  let :signature do
    ECDSA::Signature.new(
      0x8389df45f0703f39ec8c1cc42c13810ffcae14995bb648340219e353b63b53eb,
      0x09ec65e1c1aaeec1fd334c6b684bde2b3f573060d5b70c3a46723326e4e8a4f1,
    )
  end

  it 'can recover the public key from the digest and signature' do
    points = ECDSA.recover_public_key(group, digest, signature).to_a
    expect(points).to include public_key

    # Double check the results
    points.each do |point|
      ECDSA.check_signature!(point, digest, signature)
    end
  end

  it 'returns an Enumerator if not given a block' do
    points = ECDSA.recover_public_key(group, digest, signature)
    expect(points).to be_a_kind_of Enumerator
  end

  it 'yields public keys if given a block' do
    points = []
    result = ECDSA.recover_public_key(group, digest, signature) do |point|
      points << point
      ECDSA.check_signature!(point, digest, signature)
    end
    expect(result).to be_nil
    expect(points).to include public_key
  end

  it 'also works for a group with cofactor > 1' do
    group = ECDSA::Group::Secp112r2

    public_key = group.new_point [
      0xaa4ae790df9561195766c97dc1be,
      0x0cf3d4295fb062d227e8932f6e4c,
    ]

    signature = ECDSA::Signature.new(
      0x041ef05c6308e84bef9bb55255a2,
      0x33d38ed36ad0b94a182455bb3dac,
    )

    points = ECDSA.recover_public_key(group, digest, signature).to_a
    expect(points).to include public_key

    # Double check the results
    points.each do |point|
      ECDSA.check_signature!(point, digest, signature)
    end
  end

end
