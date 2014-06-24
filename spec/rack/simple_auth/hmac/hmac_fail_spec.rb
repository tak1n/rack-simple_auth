require 'spec_helper'

describe Rack::SimpleAuth::HMAC do
  def app
    Minitest::Spec.failapp
  end

  before do
    @signature = "test_signature"
    @secret = "test_secret"
  end

  after do
    system("rm -rf #{Rack::SimpleAuth.root}/test/configs/logs")
  end

  it "should fail at request time for unknown param option" do
    uri = '/'
    content = { 'method' => 'GET', 'data' => uri }.to_json
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, content)

    Proc.new { get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}" }.must_raise(RuntimeError)
  end

  it "should fail at instantiation for unknown dsl option" do
    Proc.new { Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/spec/configs/config_fail_option.ru").first }
      .must_raise(RuntimeError)
  end
end
