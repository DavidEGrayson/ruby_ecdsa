source 'https://rubygems.org/'

gem 'rspec'

gem 'rubocop', '0.20.1'
gem 'simplecov'

gem 'yard'
gem 'markdown'
if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.2.2")
  # NOTE: markdown depends on textutils, and textutils depends on AS.
  # AS5 requires Ruby2.2.2 or later.
  gem 'activesupport', '< 5'
end

platforms :ruby, :rbx do
  gem 'redcarpet'
end