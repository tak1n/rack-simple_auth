ENV['RACK_ENV'] = 'test'

require 'simplecov'
require 'coveralls'
require 'codeclimate-test-reporter'

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

  CodeClimate::TestReporter.start
end

# Rack Test Methods
require 'rspec'
require 'rack/test'

require 'json'

# Load gem
require 'rack/simple_auth'

# configure rspec to include rack-test
RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.color_enabled = true
end

module Rack
  module SimpleAuth
    module HMAC
      class << self
        attr_accessor :testapp, :failapp, :failrunapp
      end
    end
  end
end

Rack::SimpleAuth::HMAC.testapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/spec/configs/config.ru").first
Rack::SimpleAuth::HMAC.failapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/spec/configs/config_fail.ru").first
Rack::SimpleAuth::HMAC.failrunapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/spec/configs/config_fail_run.ru").first
