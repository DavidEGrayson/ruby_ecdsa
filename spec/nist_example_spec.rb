require 'spec_helper'

# Examples came from http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/ECDSA_Prime.pdf

describe 'NIST P-192 examples' do
  let(:group) { ECDSA::Group::Nistp192 }
  
  describe 'private key generation with C and D' do
    let(:c) { 0x78916860_32FD8057_F636B44B_1F47CCE5_64D25099_23A7465A }
    
    it 'gives the right coordinates' do
      pending 'not sure how this works since the test below did not pass'
      point = group.new_point(c)
      expect(point.coords).to eq [
        0xFBA2AAC6_47884B50_4EB8CD5A_0A1287BA_BCC62163_F606A9A2,
        0xDAE6D4CC_05EF4F27_D79EE38B_71C9C8EF_4865D988_50D84AA5,
      ]
    end
  end
  
  describe 'private key generation with K' do
    let(:k) { 0xD06CB0A0_EF2F708B_0744F08A_A06B6DEE_DEA9C0F8_0A69D847 }
    
    it 'gives the right coordinates' do
      pending 'not sure how this works since the test below did not pass'
      point = group.new_point(k)
      expect(point.coords).to eq [
        0xFBA2AAC6_47884B50_4EB8CD5A_0A1287BA_BCC62163_F606A9A2,
        0xDAE6D4CC_05EF4F27_D79EE38B_71C9C8EF_4865D988_50D84AA5,
      ]
    end
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


