require 'spec_helper'

describe Rack::SimpleAuth::HMAC do
  def app
    Minitest::Spec.failrunapp
  end

  before do
    @secret = "test_secret"
    @signature = "test_signature"
  end

  after do
    system("rm -rf #{Rack::SimpleAuth.root}/test/configs/logs")
  end

  it "should not be runnable" do
    uri = '/'
    content = { 'method' => 'GET', 'data' => uri }.to_json
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, content)

    Proc.new { get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}" }
      .must_raise(NoMethodError)
   end
end
