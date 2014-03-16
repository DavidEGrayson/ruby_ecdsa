require 'spec_helper'

# Examples came from http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/ECDSA_Prime.pdf
# Key generation procedures came from http://csrc.nist.gov/publications/fips/fips186-3/fips_186-3.pdf

describe 'NIST P-192 examples' do
  let(:group) { ECDSA::Group::Nistp192 }
  let(:d) { 0x78916860_32FD8057_F636B44B_1F47CCE5_64D25099_23A7465B }

  specify 'private key generation with C and D' do    
    point = group.new_point(d)
    expect(point.coords).to eq [
      0xFBA2AAC6_47884B50_4EB8CD5A_0A1287BA_BCC62163_F606A9A2,
      0xDAE6D4CC_05EF4F27_D79EE38B_71C9C8EF_4865D988_50D84AA5,
    ]
  end
  
  # TODO: figure out how the private key generation with K works in ECDSA_Prime.pdf
  # All I know is that k is one more than c but I don't know how to get a point from K.

  specify 'signature generation' do
    k = 0xD06CB0A0_EF2F708B_0744F08A_A06B6DEE_DEA9C0F8_0A69D847  # (the random number)
    e = 0x1B376F0B_735C615C_EEEB31BA_EE654B0A_374825DB
    signature = ECDSA.sign(group, d, e, k)
    expect(signature.components).to eq [
      0xF0ECBA72_B88CDE39_9CC5A18E_2A8B7DA5_4D81D04F_B9802821,
      0x1E6D3D4A_E2B1FAB2_BD2040F5_DABF00F8_54FA140B_6D21E8ED,
    ]
  end
end

describe 'NIST P-224 examples' do
  let(:group) { ECDSA::Group::Nistp224 }
  let(:d) { 0x3F0C488E_987C80BE_0FEE521F_8D90BE60_34EC69AE_11CA72AA_777481E8 }

  specify 'private key generation with C and D' do    
    point = group.new_point(d)
    expect(point.coords).to eq [
      0xE84FB0B8_E7000CB6_57D7973C_F6B42ED7_8B301674_276DF744_AF130B3E,
      0x4376675C_6FC5612C_21A0FF2D_2A89D298_7DF7A2BC_52183B59_82298555,
    ]
  end
  
  # TODO: figure out how the private key generation with K works in ECDSA_Prime.pdf
  # All I know is that k is one more than c but I don't know how to get a point from K.

  specify 'signature generation' do
    k = 0xA548803B_79DF17C4_0CDE3FF0_E36D0251_43BCBBA1_46EC3290_8EB84937   # (the random number)
    e = 0x1F1E1CF8_92926CFC_CFC5A28F_EEF3D807_D23F7780_08DBA4B3_5F04B2FD
    signature = ECDSA.sign(group, d, e, k)
    expect(signature.components).to eq [
      0xC3A3F5B8_27125320_04C6F6D1_DB672F55_D931C340_9EA1216D_0BE77380,
      0xC5AA1EAE_6095DEA3_4C9BD84D_A3852CCA_41A8BD9D_5548F36D_ABDF6617,
    ]
  end
end

describe 'NIST P-256 signature verification example' do

  let(:group) do
    ECDSA::Group::Nistp256
  end

  let (:public_key) do
    group.new_point [
      0xB7E08AFD_FE94BAD3_F1DC8C73_4798BA1C_62B3A0AD_1E9EA2A3_8201CD08_89BC7A19,
      0x3603F747_959DBF7A_4BB226E4_19287290_63ADC7AE_43529E61_B563BBC6_06CC5E09,
    ]
  end

  let(:digest) do
    0xA41A41A1_2A799548_211C410C_65D8133A_FDE34D28_BDD542E4_B680CF28_99C8A8C4
  end

  let(:signature) do
    ECDSA::Signature.new [
      0x2B42F576_D07F4165_FF65D1F3_B1500F81_E44C316F_1F0B3EF5_7325B69A_CA46104F,
      0xDC42C212_2D6392CD_3E3A993A_89502A81_98C1886F_E69D262C_4B329BDB_6B63FAF1,
    ]
  end

  it 'can verify the key is on the curve' do
    expect(group).to include public_key
  end

  it 'can be verify the signature' do
    result = ECDSA.check_signature!(public_key, digest, signature)
    expect(result).to eq true
  end

end


