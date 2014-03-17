require 'rack/simple_auth/version'
require 'rack/simple_auth/hmac'
require 'rack/simple_auth/simple_auth_helper'

require 'json'

# Rack Module
module Rack
  # Module which Contains different Authorization / Authentication Classes (HMAC, ..)
  module SimpleAuth
    include SimpleAuthHelper
  end
end
