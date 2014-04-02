require 'rack/lobster'
require 'rack/simple_auth'

config = {
  'GET' => 'path',
  'POST' => 'params',
  'DELETE' => 'path',
  'PUT' => 'path',
  'PATCH' => 'path',
  'tolerance' => 2,
  'signature' => 'test_signature',
  'secret' => 'test_secret',
  'logpath' => "#{File.expand_path('..', __FILE__)}/logs"
}

use Rack::SimpleAuth::HMAC, config
run Rack::Lobster.new
