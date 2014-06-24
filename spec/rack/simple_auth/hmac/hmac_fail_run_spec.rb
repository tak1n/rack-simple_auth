require 'spec_helper.rb'

class Minitest::Spec
  def app
    failrunapp
  end
end

describe Rack::SimpleAuth::HMAC do
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
