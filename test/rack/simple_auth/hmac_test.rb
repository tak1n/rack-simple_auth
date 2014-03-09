require 'test_helper.rb'

# Test HMAC Authorization Method
class HMACTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @secret = 'test_secret'
    @signature = 'test_signature'
  end

  def app
    Rack::SimpleAuth.testapp
  end

  def test_get_without_auth_header
    get '/'
    assert_equal(401, last_response.status, 'Unauthorized reqeust should receive 401')
  end

  def test_get_with_wrong_auth_header
    get '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'
    assert_equal(401, last_response.status, 'Wrong HTTP_AUTHORIZATION Header should receive 401')
  end

  def test_get_with_right_auth_header
    uri = '/'
    content = { 'method' => 'GET', 'data' => uri }.to_json
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), @secret, content)

    get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

    assert_equal(200, last_response.status, 'Authorized Request should receive 200')
  end

  def test_post_with_wrong_auth_header
    post '/', { 'name' => 'Bensn' }, 'HTTP_AUTHORIZATION' => 'wrong_header'
    assert_equal(401, last_response.status, 'Wrong HTTP_AUTHORIZATION Header should receive 401')
  end

  def test_post_with_right_auth_header
    params = { 'name' => 'Bensn' }
    content = { 'method' => 'POST', 'data' => params }.to_json
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), @secret, content)

    post '/', params, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

    assert_equal(200, last_response.status, 'Authorized Request should receive 200')
  end

  def test_delete_with_wrong_auth_header
    delete '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'
    assert_equal(401, last_response.status, 'Wrong HTTP_AUTHORIZATION Header should receive 401')
  end

  def test_delete_with_right_auth_header
    uri = '/'
    content = { 'method' => 'DELETE', 'data' => uri }.to_json
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), @secret, content)

    delete uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

    assert_equal(200, last_response.status, 'Authorized Request should receive 200')
  end

  def test_put_with_wrong_auth_header
    put '/', { 'name' => 'Bensn' }, 'HTTP_AUTHORIZATION' => 'wrong_header'
    assert_equal(401, last_response.status, 'Wrong HTTP_AUTHORIZATION Header should receive 401')
  end

  def test_post_with_right_auth_header
    params = { 'name' => 'Bensn' }
    content = { 'method' => 'PUT', 'data' => params }.to_json
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), @secret, content)

    put '/', params, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

    assert_equal(200, last_response.status, 'Authorized Request should receive 200')
  end

  def teardown
  end
end
