# Source: http://www.secg.org/collateral/sec2_final.pdf

module ECDSA
  class Group
    Secp128r1 = new(
      name: 'secp128r1',
      p: 0xFFFFFFFD_FFFFFFFF_FFFFFFFF_FFFFFFFF,
      a: 0xFFFFFFFD_FFFFFFFF_FFFFFFFF_FFFFFFFC,
      b: 0xE87579C1_1079F43D_D824993C_2CEE5ED3,
      g: [0x161FF752_8B899B2D_0C28607C_A52C5B86,
          0xCF5AC839_5BAFEB13_C02DA292_DDED7A83],
      n: 0xFFFFFFFE_00000000_75A30D1B_9038A115,
      h: 1,
    )
  end
end
