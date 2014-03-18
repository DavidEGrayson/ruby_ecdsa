# This file was written by hand.

require_relative 'lib/ecdsa/version'

Gem::Specification.new do |s|
  s.name = 'ecdsa'
  s.version  = RPicSim::VERSION
  s.date = Time.now.strftime('%Y-%m-%d')

  # The summary should be the same as the description at https://github.com/DavidEGrayson/ruby_ecdsa
  s.summary = 'This gem implements the Ellipctic Curve Digital Signature Algorithm (ECDSA) almost entirely in pure Ruby.'
  s.homepage = 'https://github.com/pololu/rpicsim'

  s.authors = ['David Grayson']
  s.email = 'davidegrayson@gmail.com'
  s.license = ''  # TODO: specify license

  s.required_rubygems_version = Gem::Requirement.new('>= 2')

  s.files = Dir['lib/**/*.rb', 'Gemfile', 'README.md']
  # TODO: add LICENSE.txt
end