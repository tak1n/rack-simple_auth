ENV['RACK_ENV'] = 'test'

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  project_name 'rack-simple_auth'
  add_filter '/test/'
  add_filter '/pkg/'
  add_filter '/spec/'
  add_filter '/features/'
  add_filter '/doc/'
end if ENV['COVERAGE']

# Minitest
require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/pride' # for colored output

# Rack Test Methods
require 'rack/test'

require 'json'

# Load gem
require 'rack/simple_auth'

module Rack
  # Module which Contains different Authorization / Authentication Classes (HMAC, ..)
  module SimpleAuth
    # HMAC module
    module HMAC
      class << self
        attr_accessor :testapp, :failapp, :failrunapp
      end
    end
  end
end

Rack::SimpleAuth::HMAC.testapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/test/rack/simple_auth/hmac/config.ru").first
Rack::SimpleAuth::HMAC.failapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/test/rack/simple_auth/hmac/config_fail.ru").first
Rack::SimpleAuth::HMAC.failrunapp = Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/test/rack/simple_auth/hmac/config_fail_run.ru").first

@logpath = "#{File.expand_path("..", __FILE__)}/logs"
system("mkdir #{@logpath}")
