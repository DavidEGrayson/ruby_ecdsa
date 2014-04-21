if ENV['COVERAGE'] == 'Y'
  require 'simplecov'
  SimpleCov.start
end

$LOAD_PATH << 'lib'
require 'ecdsa'
