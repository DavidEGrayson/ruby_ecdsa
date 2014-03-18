# Source: http://csrc.nist.gov/groups/ST/toolkit/documents/dss/NISTReCur.pdf

module ECDSA
  class Group
    Nistp192 = new(
      name: 'nistp192',
      p: 62771017353866807638357894232076664160839087_00390324961279,
      a: -3,
      b: 0x64210519_e59c80e7_0fa7e9ab_72243049_feb8deec_c146b9b1,
      g: [0x188da80e_b03090f6_7cbf20eb_43a18800_f4ff0afd_82ff1012,
          0x07192b95_ffc8da78_631011ed_6b24cdd5_73f977a1_1e794811],
      n: 62771017353866807638357894231760590137671947_73182842284081,
      h: nil,  # cofactor not given in NIST document
    )
  end
end
