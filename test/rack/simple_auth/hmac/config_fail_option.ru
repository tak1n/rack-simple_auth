require 'rack/lobster'
require 'rack/simple_auth'

request_config = {
  'GET' => 'path',
  'POST' => 'params',
  'DELETE' => 'path',
  'PUT' => 'path',
  'PATCH' => 'path'
}

use Rack::SimpleAuth::HMAC::Middleware do |options|
  options.tolerance = 500

  options.secret = 'test_secret'
  options.signature = 'test_signature'

  # options.logpath = "#{File.expand_path('..', __FILE__)}/logs"
  options.request_config = request_config
  options.unknown_option = 'unknown'
end

run Rack::Lobster.new
