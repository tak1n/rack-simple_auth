require 'spec_helper'

describe Rack::SimpleAuth::HMAC do
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

  describe 'GET Request' do
    context 'when not valid' do
      it 'should return status 401 (No Auth Header)' do
        get '/'
        expect(last_response.status).to eq(401)
      end

      it 'should return status 401 (Wrong Auth Header)' do
        get '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'
        expect(last_response.status).to eq(401)
      end

      it 'should return status 401 (Too Big Delay)' do
        uri = '/'
        message = { 'method' => 'GET', 'date' => now - 5000, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        expect(last_response.status).to eq(401)
      end

      it 'should return status 401 (Contains Futire Timestamp)' do
        uri = '/'
        message = { 'method' => 'GET', 'date' => now + 1500, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        expect(last_response.status).to eq(401)
      end

      it 'should return status 401 (Wrong Stepsize)' do
        uri = '/'
        message = { 'method' => 'GET', 'date' => now + 0.035, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        expect(last_response.status).to eq(401)
      end
    end

    context 'when valid' do
      it 'should return status 200' do
        uri = '/'
        message = { 'method' => 'GET', 'date' => now, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        expect(last_response.status).to eq(200)
      end

      it 'should return status 200 (In Tolerance Range)' do
        uri = '/'
        message = { 'method' => 'GET', 'date' => now - 200, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        expect(last_response.status).to eq(200)
      end
    end
  end

  describe 'POST Request' do
    context 'when invalid' do
      it 'should return status 401 (Wrong Header)' do
        post '/', { 'name' => 'Bensn' }, 'HTTP_AUTHORIZATION' => 'wrong_header'
        expect(last_response.status).to eq(401)
      end
    end

    context 'when valid' do
      it 'should return status 200' do
        params = { 'name' => 'Bensn' }
        message = { 'method' => 'POST', 'date' => now, 'data' => params }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        post '/', params, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        expect(last_response.status).to eq(200)
      end
    end
  end

  describe 'DELETE Request' do
    context 'when invalid' do
      it 'should return status 401 (Wrong Header)' do
        delete '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'
        expect(last_response.status).to eq(401)
      end
    end

    context 'when valid' do
      it 'should return status 200' do
        uri = '/'
        message = { 'method' => 'DELETE', 'date' => now, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        delete uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        expect(last_response.status).to eq(200)
      end
    end
  end

  describe 'PUT Request' do
    context 'when invalid' do
      it 'should return status 401 (Wrong Header)' do
        put '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'
        expect(last_response.status).to eq(401)
      end
    end

    context 'when valid' do
      it 'should return status 200' do
        uri = '/'
        message = { 'method' => 'PUT', 'date' => now, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        put uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        expect(last_response.status).to eq(200)
      end
    end
  end

  describe 'PATCH Request' do
    context 'when invalid' do
      it 'should return status 401 (Wrong Header)' do
        patch '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'
        expect(last_response.status).to eq(401)
      end
    end

    context 'when valid' do
      it 'should return status 200 fora patch request with a valid auth header' do
        uri = '/'
        message = { 'method' => 'PATCH', 'date' => now, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        patch uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        expect(last_response.status).to eq(200)
      end
    end
  end
end
