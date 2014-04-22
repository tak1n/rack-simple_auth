require 'rack/lobster'
require 'rack/simple_auth'

config = {
  'GET' => 'path',
  'POST' => 'params',
  'DELETE' => 'path',
  'PUT' => 'path',
  'PATCH' => 'path',
  'tolerance' => 1,
  'signature' => 'test_signature',
  'secret' => 'test_secret',
  'logpath' => "#{File.expand_path('..', __FILE__)}/logs",
  'steps' => 0.01
}

use Rack::SimpleAuth::HMAC, config
run Rack::Lobster.new
