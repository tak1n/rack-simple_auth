ENV['RACK_ENV'] = 'test'

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  project_name 'rack-simple_auth'
  add_filter '/spec/'
  add_filter '/pkg/'
  add_filter '/spec/'
  add_filter '/features/'
  add_filter '/doc/'
end if ENV['COVERAGE']

# Minispec
gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
# require 'minitest/reporters'

# reporter_options = { color: true, slow_count: 5 }
# Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

# Rack spec Methods
require 'rack/test'

require 'json'

# Load gem
require 'rack/simple_auth'

class Minitest::Spec
  include Rack::Test::Methods

  def now
    (Time.now.to_f * 1000).to_i
  end

  class << self
    attr_accessor :testapp, :failapp, :failrunapp
  end
end

Minitest::Spec.testapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/spec/configs/config.ru").first
Minitest::Spec.failapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/spec/configs/config_fail.ru").first
Minitest::Spec.failrunapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/spec/configs/config_fail_run.ru").first
