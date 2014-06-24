require 'spec_helper'

# Test HMAC Authorization Method
describe Rack::SimpleAuth::HMAC do
  parallelize_me!

  def app
    Minitest::Spec.testapp
  end

  before do
    @secret = "test_secret"
    @signature = "test_signature"
  end

  after do
    system("rm -rf #{Rack::SimpleAuth.root}/spec/configs/logs")
  end

  describe "GET Request" do
    describe "without auth header" do
      it "should receive 401" do
        get '/'

        last_response.status.must_equal 401
      end
    end

    describe "wrong auth header" do
      it "should receive 401" do
        get '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'

        last_response.status.must_equal 401
      end
    end

    describe "too big delay in header timestamp" do
      it "should receive 401" do
        uri = '/'
        message = { 'method' => 'GET', 'date' => now - 5000, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        last_response.status.must_equal 401
      end
    end

    describe "contains future timestamp in header" do
      it "should receive 401" do
        uri = '/'
        message = { 'method' => 'GET', 'date' => now + 1500, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        last_response.status.must_equal 401
      end
    end

    describe "contains wrong stepsize for timestamp in header" do
      it "should receive 401" do
        uri = '/'
        message = { 'method' => 'GET', 'date' => now + 0.035, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        last_response.status.must_equal 401
      end
    end

    describe "with valid header" do
      it "should receive 200" do
        uri = '/'
        message = { 'method' => 'GET', 'date' => now, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        last_response.status.must_equal 200
      end
    end

    describe "with timestamp in header in tolerance range" do
      it "should receive 200" do
        uri = '/'
        message = { 'method' => 'GET', 'date' => now - 200, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        last_response.status.must_equal 200
      end
    end
  end

  describe "POST Request" do
    describe "when invalid" do
      it "should receive 401" do
        post '/', { 'name' => 'Bensn' }, 'HTTP_AUTHORIZATION' => 'wrong_header'

        last_response.status.must_equal 401
      end
    end

    describe "when valid" do
      it "should receive 200" do
        params = { 'name' => 'Bensn' }
        message = { 'method' => 'POST', 'date' => now, 'data' => params }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        post '/', params, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        last_response.status.must_equal 200
      end
    end
  end

  describe "DELETE Request" do
    describe "when invalid" do
      it "should receive 401" do
        delete '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'

        last_response.status.must_equal 401
      end
    end

    describe "when valid" do
      it "should receive 200" do
        uri = '/'
        message = { 'method' => 'DELETE', 'date' => now, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        delete uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        last_response.status.must_equal 200
      end
    end
  end

  describe "PUT Request" do
    describe "when invalid" do
      it "should receive 401" do
        put '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'

        last_response.status.must_equal 401
      end
    end

    describe "when valid" do
      it "should receive 200" do
        uri = '/'
        message = { 'method' => 'PUT', 'date' => now, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        put uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        last_response.status.must_equal 200
      end
    end
  end

  describe "PATCH Request" do
    describe "when invalid" do
      it "should receive 401" do
        patch '/', {}, 'HTTP_AUTHORIZATION' => 'wrong_header'

        last_response.status.must_equal 401
      end
    end

    describe "when valid" do
      it "should receive 200" do
        uri = '/'
        message = { 'method' => 'PATCH', 'date' => now, 'data' => uri }.to_json
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message)

        patch uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}"

        last_response.status.must_equal 200
      end
    end
  end
end
