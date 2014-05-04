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
  options.tolerance = 1000

  options.secret = 'test_secret'
  options.signature = 'test_signature'

  options.logpath = "#{File.expand_path('..', __FILE__)}/logs"
  # options.verbose = true
  options.request_config = request_config
end

run Rack::Lobster.new
