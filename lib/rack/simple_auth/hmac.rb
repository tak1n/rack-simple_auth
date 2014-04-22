module Rack
  # Module which Contains different Authorization / Authentication Classes (HMAC, ..)
  module SimpleAuth
    # HMAC Middleware uses HMAC Authorization for Securing an REST API
    class HMAC
      # Constructor for Rack Middleware (passing the rack stack)
      # @param [Rack Application] app [next middleware or rack app which gets called]
      # @param [Hash] config [config hash where tolerance, secret, signature etc.. are set]
      def initialize(app, config)
        @app = app
        @signature = config['signature'] || ''
        @secret = config['secret'] || ''
        @tolerance = config['tolerance'] || 1 # 0 if tolerance not set in config hash
        @logpath = config['logpath']
        @steps = config['steps'] || 1

        min = 0.01
        if @steps < min
          puts "Warning: Minimum allowed stepsize is #{min}"
          @steps = min
        end

        if @tolerance < @steps
          fail "Tolerance must be greater than stepsize - Tolerance: #{@tolerance}, Stepsize: #{@steps}"
        end

        @config = config
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
        hash_array = build_allowed_messages(request)

        if request.env['HTTP_AUTHORIZATION'].nil?
          log(request, hash_array)

          return false
        end

        auth_array = request.env['HTTP_AUTHORIZATION'].split(':')
        message_hash = auth_array[0]
        signature = auth_array[1]

        if signature == @signature && hash_array.include?(message_hash)
          true
        else
          log(request, hash_array)

          false
        end
      end

      # Builds Array of allowed message hashs
      # @param [Rack::Request] request [current Request]
      # @return [Array] hash_array [allowed message hashes as array]
      def build_allowed_messages(request)
        hash_array = []

        (-(@tolerance)..@tolerance).step(@steps) do |i|
          i = i.round(2)
          hash_array << OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message(request, i))
        end

        hash_array
      end

      # Get Message for current Request and delay
      # @param [Rack::Request] request [current Request]
      # @param [Fixnum] delay [delay in timestamp format]
      # @return [Hash] message [message which will be encrypted]
      def message(request, delay = 0)
        date = Time.now.to_i + delay

        if delay.eql?(0.0)
          date = date.to_i
        end

        case request.request_method
        when 'GET'
          return { 'method' => request.request_method, 'date' => date, 'data' => request_data(request, @config) }.to_json
        when 'POST'
          return { 'method' => request.request_method, 'date' => date, 'data' => request_data(request, @config) }.to_json
        when 'DELETE'
          return { 'method' => request.request_method, 'date' => date, 'data' => request_data(request, @config) }.to_json
        when 'PUT'
          return { 'method' => request.request_method, 'date' => date, 'data' => request_data(request, @config) }.to_json
        when 'PATCH'
          return { 'method' => request.request_method, 'date' => date, 'data' => request_data(request, @config) }.to_json
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

      # Log to @logpath if request is unathorized
      # @param [Rack::Request] request [current Request]
      def log(request, hash_array)
        if @logpath
          path = request.path
          method = request.request_method

          log = "#{Time.new} - #{method} #{path} - 400 Unauthorized - HTTP_AUTHORIZATION: #{request.env['HTTP_AUTHORIZATION']}\n"
          log << "Auth Message Config: #{@config[request.request_method]}\n"

          if hash_array
            log << "Allowed Encrypted Messages:\n"
            hash_array.each do |hash|
              log << "#{hash}\n"
            end
          end

          log << "Auth Signature: #{@signature}"

          open("#{@logpath}/#{ENV['RACK_ENV']}_error.log", 'a') do |f|
            f << "#{log}\n"
          end
        end
      end

      private :log, :request_data, :message, :valid?, :build_allowed_messages
    end
  end
end
