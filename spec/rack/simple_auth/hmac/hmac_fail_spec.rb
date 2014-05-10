require 'spec_helper'

describe 'HMAC Fail Test' do
  before(:all) do
    @signature = 'test_signature'
    @secret    = 'test_secret'
  end

  def app
    Rack::SimpleAuth::HMAC.failapp
  end

  it 'should fail at request time for unknown param option' do
    uri = '/'
    content = { 'method' => 'GET', 'data' => uri }.to_json
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, content)

    expect { get uri, {}, 'HTTP_AUTHORIZATION' => "#{hash}:#{@signature}" }.to raise_error(RuntimeError)
  end

  it 'should fail at instantiation for unknown dsl option' do
    expect { Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/spec/configs/config_fail_option.ru").first }
      .to raise_error(RuntimeError)
  end
end
