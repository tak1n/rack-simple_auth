require 'test_helper.rb'

# Test HMAC Authorization Method
class HMACFailStepTest < MiniTest::Unit::TestCase
  def setup
    @secret = 'test_secret'
    @signature = 'test_signature'
  end

  def app
  end

  def test_fail_step
    out, err = capture_io do
      Rack::Builder.parse_file("#{Rack::SimpleAuth.root}/test/config_fail_step.ru").first
    end

    assert_match('Warning: Minimum allowed stepsize is 0.01', out, 'Warning should be printed if stepsize is below 0.01')
  end

  def teardown
  end
end
