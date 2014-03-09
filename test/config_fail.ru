require 'rack/lobster'
require 'rack/simple_auth'

config = {
  'GET' => 'pathasdf',
  'POST' => 'paramas',
  'DELETE' => 'path',
  'PUT' => 'path',
  'PATCH' => 'path'
}

use Rack::SimpleAuth::HMAC, 'test_signature', 'test_secret', config
run Rack::Lobster.new