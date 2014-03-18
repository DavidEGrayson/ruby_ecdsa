# Source: http://www.secg.org/collateral/sec2_final.pdf

module ECDSA
  class Group
    Secp160k1 = new(
      name: 'secp160k1',
      p: 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFAC73,
      a: 0,
      b: 7,
      g: [0x3B4C382C_E37AA192_A4019E76_3036F4F5_DD4D7EBB,
          0x938CF935_318FDCED_6BC28286_531733C3_F03C4FEE],
      n: 0x01_00000000_00000000_0001B8FA_16DFAB9A_CA16B6B3,
      h: 1,
    )
  end
end
