require 'rack/lobster'
require 'rack/simple_auth'

request_config = {
  'GET' => 'pathasdf',
  'POST' => 'paramas',
  'DELETE' => 'path',
  'PUT' => 'path',
  'PATCH' => 'path',
}

# Middleware should not be runnable...
run Rack::SimpleAuth::HMAC::Middleware do |options|
  options.tolerance = 500

  options.secret = 'test_secret'
  options.signature = 'test_signature'

  options.logpath = "#{File.expand_path('..', __FILE__)}/logs"
  options.verbose = true
  options.request_config = request_config
end
