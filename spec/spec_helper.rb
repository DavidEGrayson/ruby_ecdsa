$LOAD_PATH << 'lib'
require 'ecdsa'

class ConvertToMatcher
  def initialize(expected, converter)
    @expected = expected
    @converter = converter
  end
  
  def matches?(input)
    @input = input
    @output = @converter.call(input)
    @output == @expected
  end
  
  def failure_message
    "expected: convert to #{@expected.inspect}, but got #{@output.inspect}"
  end
end

module ConvertToMatcherContext
  def convert_to(expected)
    raise 'Need to set converter first.' if !converter
    ConvertToMatcher.new(expected, converter)
  end
end