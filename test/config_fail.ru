require 'rack/lobster'
require 'rack/simple_auth'

config = {
  'GET' => 'pathasdf',
  'POST' => 'paramas',
  'DELETE' => 'path',
  'PUT' => 'path',
  'PATCH' => 'path',
  'signature' => 'test_signature',
  'secret' => 'test_secret'
}

use Rack::SimpleAuth::HMAC, config
run Rack::Lobster.new
