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
        # @TODO: handle all rest request methods, get private key from file
        public_key = request.env['HTTP_X_PUBLIC_KEY'] # X-Public-Key
        content_hash = request.env['HTTP_X_CONTENT_HASH'] # X-Content-Hash
        private_key = 'e249c439ed7697df2a4b045d97d4b9b7e1854c3ff8dd668c779013653913572e';

        case request.request_method
          when 'GET'
            content = request.path
          when 'POST'
            content = request.params
        end

        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), private_key, content)

        puts request.request_method
        puts "Hash to Check: #{hash}"
        # puts "Content: #{content}"
        # puts "Public Key: #{public_key}"
        puts "Content Hash: #{content_hash}"

        if public_key == "test" && hash == content_hash
          true
        else
          false
        end
      end
    end
  end
end
