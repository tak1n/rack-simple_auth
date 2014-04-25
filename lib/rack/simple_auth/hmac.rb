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

        valid_stepsize?(0.01)
        valid_tolerance?

        @config = config
      end

      # call Method for Rack Middleware/Application
      # @param [Hash] env [Rack Env Hash which contains headers etc..]
      def call(env)
        @request = Rack::Request.new(env)

        if valid_request?
          @app.call(env)
        else
          response = Rack::Response.new('Unauthorized', 401, 'Content-Type' => 'text/html')
          response.finish
        end
      end

      # checks for valid HMAC Request
      # @return [boolean] ValidationStatus [If authorized returns true, else false]
      def valid_request?
        if @request.env['HTTP_AUTHORIZATION'].nil?
          log(allowed_messages)

          return false
        end

        if request_signature == @signature && allowed_messages.include?(request_message)
          true
        else
          log(allowed_messages)

          false
        end
      end

      private

      # Get request signature
      def request_signature
        @request.env['HTTP_AUTHORIZATION'].split(':').last
      end

      # Get encrypted request message
      def request_message
        @request.env['HTTP_AUTHORIZATION'].split(':').first
      end

      # Builds Array of allowed message hashs
      # @return [Array] hash_array [allowed message hashes as array]
      def allowed_messages
        messages = []

        (-(@tolerance)..@tolerance).step(@steps) do |i|
          i = i.round(2)
          messages << OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, message(i))
        end

        messages
      end

      # Get Message for current Request and delay
      # @param [Fixnum] delay [delay in timestamp format]
      # @return [Hash] message [message which will be encrypted]
      def message(delay = 0)
        date = Time.now.to_i + delay
        date = date.to_i if delay.eql?(0.0)

        case @request.request_method
        when 'GET'
          return { 'method' => @request.request_method, 'date' => date, 'data' => request_data(@config) }.to_json
        when 'POST'
          return { 'method' => @request.request_method, 'date' => date, 'data' => request_data(@config) }.to_json
        when 'DELETE'
          return { 'method' => @request.request_method, 'date' => date, 'data' => request_data(@config) }.to_json
        when 'PUT'
          return { 'method' => @request.request_method, 'date' => date, 'data' => request_data(@config) }.to_json
        when 'PATCH'
          return { 'method' => @request.request_method, 'date' => date, 'data' => request_data(@config) }.to_json
        end
      end

      # Get Request Data specified by Config
      # @param [Hash] config [Config Hash containing what type of info is data for each request]
      # @return [String|Hash] data [Data for each request]
      def request_data(config)
        if config[@request.request_method] == 'path' || config[@request.request_method] == 'params'
          @request.send(config[@request.request_method].to_sym)
        else
          fail "Not a valid option #{config[@request.request_method]} - Use either params or path"
        end
      end

      # Log to @logpath if request is unathorized
      # Contains:
      #   - allowed messages and received message
      #   - time when request was made
      #   - type of request
      #   - requested path
      def log(hash_array)
        if @logpath
          log = "#{Time.new} - #{@request.request_method} #{@request.path} - 400 Unauthorized\n"
          log << "HTTP_AUTHORIZATION: #{@request.env['HTTP_AUTHORIZATION']}\n"
          log << "Auth Message Config: #{@config[@request.request_method]}\n"

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

      # Check if Stepsize is valid, if > min ensure stepsize is min stepsize
      # @param [float] min [minimum allowed stepsize]
      def valid_stepsize?(min)
        if @steps < min
          fail "Minimum allowed stepsize is #{min}"
        end
      end

      # Check if tolerance is valid, tolerance must be greater than stepsize
      def valid_tolerance?
        if @tolerance < @steps
          fail "Tolerance must be greater than stepsize - Tolerance: #{@tolerance}, Stepsize: #{@steps}"
        end
      end
    end
  end
end
