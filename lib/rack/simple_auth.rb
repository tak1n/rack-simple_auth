require 'rack/simple_auth/version'
require 'rack/simple_auth/hmac'
require 'rack/simple_auth/helper'

require 'json'

# Rack Module
module Rack
  # Module which Contains different Authorization / Authentication Classes (HMAC, ..)
  module SimpleAuth
    include SimpleAuthHelper
  end
end
