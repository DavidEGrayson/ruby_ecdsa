# ECDSA gem for Ruby

This gem implements the Elliptic Curve Digital Signature Algorithm (ECDSA) almost entirely in pure Ruby.
It aims to be easier to use and easier to understand than Ruby's [OpenSSL EC support](http://www.ruby-doc.org/stdlib/libdoc/openssl/rdoc/OpenSSL/PKey/EC.html).
This gem does use OpenSSL but it only uses it to decode and encode ASN1 strings for ECDSA signatures.
All cryptographic calculations are done in pure Ruby.

The main classes of this gem are `ECDSA::Group`, `ECDSA::Point`, and `ECDSA::Signature`.
These classes operate on Ruby integers and do not deal at all with binary formatting.
Encoding and decoding of binary formats is solely handled by classes under the `ECDSA::Format` module.

You can enter your own curve parameters by instantiating a new `ECDSA::Group` object or you can
use a pre-existing group object such as `ECDSA::Group::Secp256k1`.
The pre-existing groups can be seen in the `lib/ecdsa/group` folder, and include all the curves
defined in [SEC2](http://www.secg.org/collateral/sec2_final.pdf) and [NIST's Recommended Elliptic Curves for Federal Government Use](http://csrc.nist.gov/groups/ST/toolkit/documents/dss/NISTReCur.pdf).

This gem does not use any randomness; all the algorithms are deterministic.
In order to sign a message, you must generate a secure random number _k_ between 0
and the order of the group and pass it as an argument to `ECDSA.sign`.
You should take measures to ensure that you never use the same random number to sign
two different messages, or else it would be easy for someone to compute your
private key from those two signatures.

This gem is hosted at the [DavidEGrayson/ruby_ecdsa github repository](https://github.com/DavidEGrayson/ruby_ecdsa).

## Current limitations

- This gem only supports fields of integers modulo a prime number (_F<sub>p</sub>_).
  ECDSA's characteristic 2 fields are not supported.
- This gem can only compute square roots in prime fields over a prime _p_
  that is one less than a multiple of 4.
  Computing a square root is required for parsing public keys stored in compressed form.
- There is no documentation.  If you know a little bit about ECDSA and know how to read
  Ruby source code, you can probably figure it out though.
- The algorithms have not been optimized for speed, and will probably never be, because that
  would hinder the goal of helping people understand ECDSA.

This gem was not written by a cryptography expert and has not been carefully checked.
It is provided "as is" and it is the user's responsibility to make sure it will be
suitable for the desired purpose.