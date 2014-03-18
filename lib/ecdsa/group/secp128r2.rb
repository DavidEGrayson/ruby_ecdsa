# Source: http://www.secg.org/collateral/sec2_final.pdf

module ECDSA
  class Group
    Secp128r2 = new(
      name: 'secp128r2',
      p: 0xFFFFFFFD_FFFFFFFF_FFFFFFFF_FFFFFFFF,
      a: 0xD6031998_D1B3BBFE_BF59CC9B_BFF9AEE1,
      b: 0x5EEEFCA3_80D02919_DC2C6558_BB6D8A5D,
      g: [0x7B6AA5D8_5E572983_E6FB32A7_CDEBC140,
          0x27B6916A_894D3AEE_7106FE80_5FC34B44],
      n: 0x3FFFFFFF_7FFFFFFF_BE002472_0613B5A3,
      h: 4,
    )
  end
end
