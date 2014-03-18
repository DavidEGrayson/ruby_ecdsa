# Source: http://csrc.nist.gov/groups/ST/toolkit/documents/dss/NISTReCur.pdf

module ECDSA
  class Group
    Nistp224 = new(
      name: 'nistp224',
      p: 26959946667150639794667015087019630673557916_260026308143510066298881,
      a: -3,
      b: 0xb4050a85_0c04b3ab_f5413256_5044b0b7_d7bfd8ba_270b3943_2355ffb4,
      g: [0xb70e0cbd_6bb4bf7f_321390b9_4a03c1d3_56c21122_343280d6_115c1d21,
          0xbd376388_b5f723fb_4c22dfe6_cd4375a0_5a074764_44d58199_85007e34],
      n: 26959946667150639794667015087019625940457807_714424391721682722368061,
      h: nil,  # cofactor not given in NIST document
    )
  end
end
