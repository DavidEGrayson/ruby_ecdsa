Change log
====

This gem follows [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).
All classes and public methods are part of the public API, unless explicitly noted otherwise
in their documentation.

1.2.0
----
Released on 2014-09-14.

- Adds aliases to `ECDSA::Point` so you can do point arithmetic with `+` and `*`
  operators.  (Thanks to Stephen McCarthy.)

1.1.0
----
Released on 2014-04-20.

New features:

- `ECDSA.recover_public_key` was added.  It finds all possible public keys that
  could have been used to make a signature.
- `Group#valid_public_key?` and `Group#partially_valid_public_key?` were added.
  They are different from `Group#include?` because they both return false for
  the infinity point and `Group#valid_public_key?` checks to make sure
  that the point can be expressed as the generator point times a scalar.
- `PrimeField#square_roots` now works all prime fields.

Bug fixes:

- The signing and verification operations now properly take the leftmost bits
  of the digest if it is a string.  If it is an integer, it is left alone.
- Nicer exception error messages from `ECDSA.check_signature!`.  They start with
  "Invalid signature: " so they could be understood in the context of a larger
  application without looking at the class of the exception.
- `ECDSA.sign` returns nil if r is zero.

1.0.0
----
Released on 2014-04-06.

- PointOctetString: Made the `decode` method treat all strings as binary.
- Group: Changed two methods to be private: `#point_satisfies_equation?` and
    `#equation_right_hand_side`.
- Group: made `#include?` return false instead of raising an exception when a
    point in another group is passed in.
- Added lots of documentation.
