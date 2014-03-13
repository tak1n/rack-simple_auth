module Rack
  # Module which Contains different Authorization / Authentication Classes (HMAC, ..)
  module SimpleAuth
    # HMAC Middleware uses HMAC Authorization for Securing an REST API
    class HMAC
      # Constructor for Rack Middleware (passing the rack stack)
      # @param [Rack Application] app [next middleware or rack app which gets called]
      # @param [String] signature [Public Signature]
      # @param [String] secret [Secret used for Message Encryption]
      def initialize(app, signature, secret, config, logpath = nil)
        @app = app
        @signature = signature
        @secret = secret
        @config = config
        @logpath = logpath
      end

      # call Method for Rack Middleware/Application
      # @param [Hash] env [Rack Env Hash which contains headers etc..]
      def call(env)
        request = Rack::Request.new(env)
        if valid?(request)
          @app.call(env)
        else
          response = Rack::Response.new('Unauthorized', 401, 'Content-Type' => 'text/html')
          response.finish
        end
      end

      # checks for valid HMAC Request
      # @param [Rack::Request] request [current Request]
      # @return [boolean] ValidationStatus [If authorized returns true, else false]
      def valid?(request)
        if request.env['HTTP_AUTHORIZATION'].nil?
          log(request, nil)

          return false
        end

        auth_array = request.env['HTTP_AUTHORIZATION'].split(':')
        message_hash = auth_array[0]
        signature = auth_array[1]

        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), @secret, message(request))

        if signature == @signature && hash == message_hash
          true
        else
          log(request, hash)

          false
        end
      end

      # Get Message for current Request
      # @param [Rack::Request] request [current Request]
      # @return [Hash] message [message which will be encrypted]
      def message(request)
        case request.request_method
        when 'GET'
          return { 'method' => request.request_method, 'data' => request_data(request, @config) }.to_json
        when 'POST'
          return { 'method' => request.request_method, 'data' => request_data(request, @config) }.to_json
        when 'DELETE'
          return { 'method' => request.request_method, 'data' => request_data(request, @config) }.to_json
        when 'PUT'
          return { 'method' => request.request_method, 'data' => request_data(request, @config) }.to_json
        when 'PATCH'
          return { 'method' => request.request_method, 'data' => request_data(request, @config) }.to_json
        end
      end

      # Get Request Data specified by Config
      # @param [Rack::Request] request [current Request]
      # @param [Hash] config [Config Hash containing what type of info is data for each request]
      # @return [String|Hash] data [Data for each request]
      def request_data(request, config)
        if config[request.request_method] == 'path' || config[request.request_method] == 'params'
          request.send(config[request.request_method].to_sym)
        else
          fail "Not a valid option #{config[request.request_method]} - Use either params or path"
        end
      end

      def log(request, hash)
        if @logpath
          path = request.path
          method = request.request_method

          log = "#{Time.new} - #{method} #{path} - 400 Unauthorized - HTTP_AUTHORIZATION: #{request.env['HTTP_AUTHORIZATION']}\n"
          log << "Auth Message Config: #{@config[request.request_method]}\n"
          log << "Auth Encrypted Message: #{hash}\n"
          log << "Auth Signature: #{@signature}\n"

          open("#{@logpath}/#{ENV['RACK_ENV']}_error.log", 'a') do |f|
            f << "#{log}\n"
          end
        end
      end
    end
  end
end
