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
require 'minitest/autorun'
require 'minitest/pride'

# Rack Test Methods
require 'rack/test'

require 'json'

# Load gem
require 'rack/simple_auth'

module Rack
  module SimpleAuth
    module HMAC
      class << self
        attr_accessor :testapp, :failapp, :failrunapp
      end
    end
  end
end

Rack::SimpleAuth::HMAC.testapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/test/configs/config.ru").first
Rack::SimpleAuth::HMAC.failapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/test/configs/config_fail.ru").first
Rack::SimpleAuth::HMAC.failrunapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/test/configs/config_fail_run.ru").first
