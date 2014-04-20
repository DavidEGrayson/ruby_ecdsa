$LOAD_PATH << 'lib'
require 'ecdsa'

if ENV['COVERAGE'] == 'Y'
  require 'simplecov'
  SimpleCov.start
end
