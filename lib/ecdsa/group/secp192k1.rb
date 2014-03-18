# Source: http://www.secg.org/collateral/sec2_final.pdf

module ECDSA
  class Group
    Secp192k1 = new(
      name: 'secp192k1',
      p: 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFEE37,
      a: 0,
      b: 3,
      g: [0xDB4FF10E_C057E9AE_26B07D02_80B7F434_1DA5D1B1_EAE06C7D,
          0x9B2F2F6D_9C5628A7_844163D0_15BE8634_4082AA88_D95E2F9D],
      n: 0xFFFFFFFF_FFFFFFFF_FFFFFFFE_26F2FC17_0F69466A_74DEFD8D,
      h: 1,
    )
  end
end
