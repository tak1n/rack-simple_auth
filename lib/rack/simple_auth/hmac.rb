module Rack
  module SimpleAuth
    class HMAC
      def initialize(app, signature, secret)
        @app = app
        @signature = signature
        @secret = secret
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
        content_hash = request.env['HTTP_AUTHORIZATION'].split(':')[0]
        signature = request.env['HTTP_AUTHORIZATION'].split(':')[1]

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

        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), @secret, content)
        puts request.request_method
        puts "Signature: #{signature}"
        puts "Hash to Check: #{hash}"
        puts "Content Hash: #{content_hash}"

        if signature == @signature && hash == content_hash
          true
        else
          false
        end
      end
    end
  end
end
