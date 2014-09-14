if ENV['COVERAGE'] == 'Y'
  require 'simplecov'
  SimpleCov.start
end

$LOAD_PATH << 'lib'
require 'ecdsa'

Davidp16d1 = ECDSA::Group.new(
  name: 'davidp16d1',
  p: 0xff8f,
  a: -3,
  b: 0x2ccd,
  g: [0, 0x5455],
  n: 0x7efb,
  h: 2,
)
