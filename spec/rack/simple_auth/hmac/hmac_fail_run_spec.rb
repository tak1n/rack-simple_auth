require 'spec_helper'

describe 'HMAC Middleware as Rack Application' do
  before(:all) do
    @secret    = 'test_secret'
    @signature = 'test_signature'
  end

  def app
    Rack::SimpleAuth::HMAC.failrunapp
  end

  it 'should not be runnable' do
    uri = '/'
    content = { 'method' => 'GET', 'data' => uri }.to_json
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, content)

    expect { get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}" }.to raise_error(NoMethodError)
  end
end


