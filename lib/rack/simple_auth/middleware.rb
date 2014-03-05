module Rack
  module SimpleAuth
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        request = Rack::Request.new(env)
        if valid?(request)
          @app.call(env)
        else
          response = Rack::Response.new("Unauthorized", 401, {'Content-Type' => 'text/html'})
          response.finish
        end
      end

      def valid?(request)
        # @todo : implement HMAC protocol
        secret = get_secret_from_configru_file

        digest = OpenSSL::Digest::Digest.new('sha1')

        true
      end
    end
  end
end
