require 'rack/simple_auth/version'
require 'rack/simple_auth/hmac'
require 'rack/simple_auth/helper'

require 'json'

# Rack Module
module Rack
  # Module which Contains different Authorization / Authentication Classes (HMAC, ..)
  module SimpleAuth
    class << self
      # Method to return Gem Root Dir
      # @return [String] Gem Root Folder
      def root
        ::File.dirname(::File.dirname(::File.expand_path('..', __FILE__)))
      end
    end
  end
end
