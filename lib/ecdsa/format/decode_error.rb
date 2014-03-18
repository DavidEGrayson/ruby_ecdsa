module ECDSA
  module Format
    # Raising instance of this class as an exception indicates that
    # the data being decoded was invalid, but does not necessarily
    # indicate a bug in the program, unlike most other exceptions
    # because it is possible the data being decoded is coming from
    # an untrusted source.
    class DecodeError < StandardError
    end
  end
end
