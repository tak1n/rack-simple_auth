require 'test_helper.rb'

# Test HMAC Authorization Method
class HMACFailTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def setup
  	@secret = 'test_secret'
    @signature = 'test_signature'
  end

  def app
    Rack::SimpleAuth.failapp
  end

  def test_fail
  	uri = '/'
    content = { 'method' => 'GET', 'data' => uri }.to_json
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), @secret, content)

    assert_raises(RuntimeError) { get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}" }
  end

  def teardown
  end
end