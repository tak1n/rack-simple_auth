module Rack
  module SimpleAuth
    module HMAC
      # class Config
      # Config objects will be instantiated out of this class when using Rack::SimpleAuth::HMAC::Middleware
      # Also the public instance attributes / virtual attributes will be populated via the Middleware DSL
      class Config < Hash
        attr_writer :tolerance, :stepsize
        attr_writer :secret, :signature
        attr_accessor :logpath, :request_config

        def method_missing(name, *args)
          fail "Unkown option #{name.to_s.gsub!('=', '')}"
        end

        def tolerance
          @tolerance || 1
        end

        def stepsize
          @stepsize || 1
        end

        def secret
          @secret || ''
        end

        def signature
          @signature || ''
        end
      end
    end
  end
end
