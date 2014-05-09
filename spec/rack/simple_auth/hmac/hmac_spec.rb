require 'spec_helper'

describe 'HMAC Middleware' do
  before(:all) do
    @secret    = 'test_secret'
    @signature = 'test_signature'
  end

  def app
    Rack::SimpleAuth::HMAC.testapp
  end

  def now
    (Time.now.to_f * 1000).to_i
  end

  describe 'GET' do
    it 'should return status 401 when no auth header was sent' do
      get '/'
      expect(last_response.status).to eq(401)
    end

    it 'should return status 401 for a wrong auth header' do
      get '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'
      expect(last_response.status).to eq(401)
    end

    it 'should return status 200 for a authenticated request' do
      uri = '/'
      message = { 'method' => 'GET', 'date' => now, 'data' => uri }.to_json
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

      get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

      expect(last_response.status).to eq(200)
    end

    it 'should return status 200 for a authenticated request in tolerance range' do
      uri = '/'
      message = { 'method' => 'GET', 'date' => now - 200, 'data' => uri }.to_json
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

      get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

      expect(last_response.status).to eq(200)
    end

    it 'should return status 401 for a request with too big delay' do
      uri = '/'
      message = { 'method' => 'GET', 'date' => now - 5000, 'data' => uri }.to_json
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

      get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

      expect(last_response.status).to eq(401)
    end

    it 'should return status 401 for hackish requests with future timestamp in it' do
      uri = '/'
      message = { 'method' => 'GET', 'date' => now + 1500, 'data' => uri }.to_json
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

      get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

      expect(last_response.status).to eq(401)
    end

    it 'should return status 401 for requests with wrong stepsize' do
      uri = '/'
      message = { 'method' => 'GET', 'date' => now + 0.035, 'data' => uri }.to_json
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

      get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

      expect(last_response.status).to eq(401)
    end
  end

  describe 'POST' do
    it 'should return status 401 for a post request with a wrong auth header' do
      post '/', { 'name' => 'Bensn' }, 'HTTP_AUTHORIZATION' => 'wrong_header'
      expect(last_response.status).to eq(401)
    end

    it 'should return status 200 for a post request with a valid auth header' do
      params = { 'name' => 'Bensn' }
      message = { 'method' => 'POST', 'date' => now, 'data' => params }.to_json
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

      post '/', params, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

      expect(last_response.status).to eq(200)
    end
  end

  describe 'DELETE' do
    it 'should return status 401 for a delete request with a wrong auth header' do
      delete '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'
      expect(last_response.status).to eq(401)
    end

    it 'should return status 200 for a delete request with a valid auth header' do
      uri = '/'
      message = { 'method' => 'DELETE', 'date' => now, 'data' => uri }.to_json
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

      delete uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

      expect(last_response.status).to eq(200)
    end
  end

  describe 'PUT' do
    it 'should return status 401 for a put request with a wrong auth header' do
      put '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'
      expect(last_response.status).to eq(401)
    end

    it 'should return status 200 for a put request with a valid auth header' do
      uri = '/'
      message = { 'method' => 'PUT', 'date' => now, 'data' => uri }.to_json
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

      put uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

      expect(last_response.status).to eq(200)
    end
  end

  describe 'PATCH' do
    it 'should return status 401 for a patch request with a wrong auth header' do
      patch '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'
      expect(last_response.status).to eq(401)
    end

    it 'should return status 200 fora patch request with a valid auth header' do
      uri = '/'
      message = { 'method' => 'PATCH', 'date' => now, 'data' => uri }.to_json
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

      patch uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

      expect(last_response.status).to eq(200)
    end
  end
end
