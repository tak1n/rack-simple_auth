ENV['RACK_ENV'] = 'test'

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

if ENV['COVERAGE']
  SimpleCov.start do
    project_name 'rack-simple_auth'
    add_filter '/test/'
    add_filter '/pkg/'
    add_filter '/spec/'
    add_filter '/features/'
    add_filter '/doc/'
  end
end

# Minitest
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'

reporter_options = { color: true, slow_count: 5 }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

# Rack Test Methods
require 'rack/test'

require 'json'

# Load gem
require 'rack/simple_auth'

class Minitest::Spec
  include Rack::Test::Methods

  def testapp
    Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/test/configs/config.ru").first
  end

  def failapp
    Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/test/configs/config_fail.ru").first
  end

  def failrunapp
    Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/test/configs/config_fail_run.ru").first
  end

  def now
    (Time.now.to_f * 1000).to_i
  end
end
