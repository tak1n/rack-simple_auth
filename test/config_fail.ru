require 'rack/lobster'
require 'rack/simple_auth'

request_config = {
  'GET' => 'pathasdf',
  'POST' => 'paramas',
  'DELETE' => 'path',
  'PUT' => 'path',
  'PATCH' => 'path',
}

use Rack::SimpleAuth::HMAC::Middleware do |options|
  options.tolerance = 0.5
  options.stepsize  = 0.01

  options.secret = 'test_secret'
  options.signature = 'test_signature'

  options.logpath = "#{File.expand_path('..', __FILE__)}/logs"
  options.request_config = request_config
end

run Rack::Lobster.new
