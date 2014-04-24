require 'test_helper.rb'

# Test HMAC Authorization Method
class HMACFailStepTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @secret = 'test_secret'
    @signature = 'test_signature'
  end

  def app
    Rack::SimpleAuth.failstepapp
  end

  def test_fail_step
    uri = '/'
    content = { 'method' => 'GET', 'data' => uri }.to_json
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, content)

    get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"
  end

  def teardown
  end
end
