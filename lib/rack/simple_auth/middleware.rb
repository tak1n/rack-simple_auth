module Rack
  module SimpleAuth
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        request = Rack::Request.new(env)
        if valid?(request.env['HTTP_X_API_KEY'])
          @app.call(env)
        else
          response = Rack::Response.new("Unauthorized", 401, {'Content-Type' => 'text/html'})
          response.finish          
        end
      end

      def valid?(key)
        # @todo : implement HMAC protocol
        if key == "1"
          true
        else
          false
        end
      end
    end
  end
end