require 'spec_helper'

describe 'nist P-256 signature verification example' do

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


