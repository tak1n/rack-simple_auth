require 'rack/lobster'
require 'rack/simple_auth'

use Rack::SimpleAuth::HMAC, 'test_signature', 'test_secret'
run Rack::Lobster.new