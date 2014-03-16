# Source: "Curve P-256" from http://csrc.nist.gov/groups/ST/toolkit/documents/dss/NISTReCur.doc

module ECDSA
  class Group
    Nistp244 = new(
      name: 'nistp192',
      p: ,      
      a: -3,
      b: ,
      g: [,
          ],
      n: ,
      h: nil,  # cofactor not given in NIST document
    )
  end
end