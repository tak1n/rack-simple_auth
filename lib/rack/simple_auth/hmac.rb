module Rack
  module SimpleAuth
    class HMAC
      def initialize(app, public_key, private_key)
        @app = app
        @public_key = public_key
        @private_key = private_key
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
        public_key = request.env['HTTP_X_PUBLIC_KEY'] # X-Public-Key
        content_hash = request.env['HTTP_X_CONTENT_HASH'] # X-Content-Hash

        case request.request_method
          when 'GET'
            content = request.path
          when 'POST'
            content = request.POST.to_json
          when 'DELETE'
            false
          when 'PUT'
            false
        end

        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), @private_key, content)
        # puts request.request_method
        # puts "Public Key: #{public_key}"
        # puts "Hash to Check: #{hash}"
        # puts "Content Hash: #{content_hash}"

        if public_key == @public_key && hash == content_hash
          true
        else
          false
        end
      end
    end
  end
end
