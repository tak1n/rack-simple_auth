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
        return false if request.env['HTTP_AUTHORIZATION'].nil?

        auth_array = request.env['HTTP_AUTHORIZATION'].split(':')
        content_hash = auth_array[0]
        signature = auth_array[1]

        case request.request_method
          when 'GET'
            content = { 'method' => request.request_method, 'data' => request.path }.to_json
          when 'POST'
            content = { 'method' => request.request_method, 'data' => request.POST }.to_json
          when 'DELETE'
            content = { 'method' => request.request_method, 'data' => request.path }.to_json
          when 'PUT'
            content = { 'method' => request.request_method, 'data' => request.POST }.to_json
        end

        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), @secret, content)
        # puts content
        # puts "Hash to Check: #{hash}"
        # puts "Content Hash: #{content_hash}"

        if signature == @signature && hash == content_hash
          true
        else
          false
        end
      end
    end
  end
end
