Change log
====

This gem follows [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).
All classes and public methods are part of the public API, unless explicitly noted otherwise
in their documentation.

1.0.0
----
Released on 2014-04-06.

- PointOctetString: Made the `decode` method treat all strings as binary.
- Group: Changed two methods to be private: `#point_satisfies_equation?` and
    `#equation_right_hand_side`.
- Group: made `#include?` return false instead of raising an exception when a
    point in another group is passed in.
- Added lots of documentation.
