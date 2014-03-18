# Source: http://www.secg.org/collateral/sec2_final.pdf

module ECDSA
  class Group
    Secp112r2 = new(
      name: 'secp112r2',
      p: 0xDB7C_2ABF62E3_5E668076_BEAD208B,
      a: 0x6127_C24C05F3_8A0AAAF6_5C0EF02C,
      b: 0x51DE_F1815DB5_ED74FCC3_4C85D709,
      g: [0x4BA3_0AB5E892_B4E1649D_D0928643,
          0xADCD_46F5882E_3747DEF3_6E956E97],
      n: 0x36DF_0AAFD8B8_D7597CA1_0520D04B,
      h: 4,
    )
  end
end
