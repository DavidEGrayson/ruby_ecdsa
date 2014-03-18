# Source: http://www.secg.org/collateral/sec2_final.pdf

module ECDSA
  class Group
    Secp112r1 = new(
      name: 'secp112r1',
      p: 0xDB7C_2ABF62E3_5E668076_BEAD208B,
      a: 0xDB7C_2ABF62E3_5E668076_BEAD2088,
      b: 0x659E_F8BA0439_16EEDE89_11702B22,
      g: [0x0948_7239995A_5EE76B55_F9C2F098,
          0xA89C_E5AF8724_C0A23E0E_0FF77500],
      n: 0xDB7C_2ABF62E3_5E7628DF_AC6561C5,
      h: 1,
    )
  end
end
