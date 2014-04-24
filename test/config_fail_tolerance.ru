require 'rack/lobster'
require 'rack/simple_auth'

config = {
  'GET' => 'path',
  'POST' => 'params',
  'DELETE' => 'path',
  'PUT' => 'path',
  'PATCH' => 'path',
  'signature' => 'test_signature',
  'secret' => 'test_secret',
  'steps' => 0.5,
  'tolerance' => 0.3
}

use Rack::SimpleAuth::HMAC, config
run Rack::Lobster.new
