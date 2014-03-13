require 'rack/lobster'
require 'rack/simple_auth'

config = {
  'GET' => 'path',
  'POST' => 'params',
  'DELETE' => 'path',
  'PUT' => 'path',
  'PATCH' => 'path',
}

use Rack::SimpleAuth::HMAC, 'test_signature', 'test_secret', config, "#{File.expand_path('..', __FILE__)}/logs"
run Rack::Lobster.new
