require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

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
