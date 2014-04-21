Change log
====

This gem follows [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).
All classes and public methods are part of the public API, unless explicitly noted otherwise
in their documentation.

2.0.0
----
Released on 2014-04-20.

Breaking changes:

- The `digest` argument to the signing and signature verifications methods can
  no longer be an integer.  It must be a string so that we can properly take the
  left-most bits of it as defined in Section 4.1.3 of SEC1 2.0.

  Prior to this change, the "leftmost bits" operation did not do what
  it was supposed to at all, probably resulting in faulty signatures
  whenever the digest had more bits than the curve.
  
  The affected methods are:
  
    - `ECDSA.sign`
    - `ECDSA.valid_signature?`
    - `ECDSA.check_signature!`

New features:

- `ECDSA.recover_public_key` was added.  It finds all possible public keys that
  could have been used to make a signature.
- `Group#valid_public_key?` and `Group#partially_valid_public_key?` were added.
  They are different from `Group#include?` because they both return false for
  the infinity point and `Group#valid_public_key?` checks to make sure
  that the point can be expressed as generator point times a scalar.
- `PrimeField#square_roots` works no matter what prime is used for the field.
  
Bug fixes:

- The signing and verification operations now properly take the leftmost bits
  of the digest.  (This caused the breaking change above.)
- Nicer exception error messages from `ECDSA.check_signature!`.  They start with
  "Invalid signature: " so they can be integrated into a larger application
  easily without showing the user bizarre error messages.

1.0.0
----
Released on 2014-04-06.

- PointOctetString: Made the `decode` method treat all strings as binary.
- Group: Changed two methods to be private: `#point_satisfies_equation?` and
    `#equation_right_hand_side`.
- Group: made `#include?` return false instead of raising an exception when a
    point in another group is passed in.
- Added lots of documentation.
