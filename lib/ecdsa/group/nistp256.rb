# Source: http://csrc.nist.gov/groups/ST/toolkit/documents/dss/NISTReCur.pdf

module ECDSA
  class Group
    Nistp256 = new(
      name: 'nistp256',
      p: 11579208921035624876269744694940757353008614_3415290314195533631308867097853951,
      a: -3,
      b: 0x5ac635d8_aa3a93e7_b3ebbd55_769886bc_651d06b0_cc53b0f6_3bce3c3e_27d2604b,
      g: [0x6b17d1f2_e12c4247_f8bce6e5_63a440f2_77037d81_2deb33a0_f4a13945_d898c296,
          0x4fe342e2_fe1a7f9b_8ee7eb4a_7c0f9e16_2bce3357_6b315ece_cbb64068_37bf51f5],
      n: 11579208921035624876269744694940757352999695_5224135760342422259061068512044369,
      h: nil,  # cofactor not given in NIST document
    )
  end
end
