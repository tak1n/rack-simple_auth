module Rack
  module SimpleAuth
    module HMAC
      class Request < Rack::Request
        def initialize(env, config)
          @env = env
          @config = config
          @allowed_messages = allowed_messages
        end

        ##
        # Checks for valid HMAC Request
        #
        # @return [TrueClass] if request is authorized
        # @return [FalseClass] if request is not authorized or HTTP_AUTHORIZATION Header is not set
        #
        def valid?
          log

          return false if empty_header? || !authorized?

          true
        end

      private

        ##
        # Builds Array of allowed message hashs between @tolerance via {#message}
        #
        # @return [Array]
        def allowed_messages
          messages = []

          # Timestamp with milliseconds as Fixnum
          date = (Time.now.to_f.freeze * 1000).to_i
          (-(@config.tolerance)..0).step(1) do |i|
            messages << OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @config.secret, build_message(date, i))
          end

          messages
        end

        ##
        # Build Message for current Request and delay
        #
        # @param [Fixnum] date [current date in timestamp format]
        # @param [Fixnum] delay [delay in timestamp format]
        #
        # @return [String] message
        def build_message(date, delay = 0)
          date += delay

          { 'method' => self.request_method, 'date' => date, 'data' => data }.to_json
        end

        ##
        # Get Request Data specified by @config.request_config
        #
        # @return [String|Hash] data
        #
        # Note: REFACTOR this shit..
        def data
          return self.send(@config.request_config[method].to_sym) if valid_message_type?

          fail "Not a valid option #{@config.request_config[method]} - Use either params or path"
        end

        ##
        # Check if HTTP_AUTHORIZATION Header is set
        #
        # @return [TrueClass] if header is set
        # @return [FalseClass] if header is not set
        #
        def empty_header?
          self.env['HTTP_AUTHORIZATION'].nil?
        end

        ##
        # Check if request is authorized
        #
        # @return [TrueClass] if request is authorized -> {#signature} is correct & {#message} is included
        #   in {#allowed_messages}
        # @return [FalseClass] if request is not authorized
        #
        def authorized?
          signature.eql?(@config.signature) && @allowed_messages.include?(message)
        end

        ##
        # Get request signature
        #
        # @return [String] signature of current request
        #
        def signature
          self.env['HTTP_AUTHORIZATION'].split(':').last
        end

        ##
        # Get encrypted request message
        #
        # @return [String] message of current request
        #
        def message
          self.env['HTTP_AUTHORIZATION'].split(':').first
        end

        ##
        # Request method for current request
        #
        # @return [String] Request Method [GET|POST|PUT|DELETE|PATCH]
        #
        def method
          self.request_method
        end

        ##
        # Check if message type for current request is valid
        #
        # @return [TrueClass] if message type for current request is path or params
        # @return [FalseClass] if message type is invalid
        #
        def valid_message_type?
          @config.request_config[method] == 'path' || @config.request_config[method] == 'params'
        end

        ##
        # Log to @config.logpath
        # Contains:
        #   - allowed messages and received message
        #   - time when request was made
        #   - type of request
        #   - requested path
        #
        # Note: This is kinda slow under Rubinius
        #   (Rack::SimpleAuth::Logger.log has IO action, i think there are some performance issues)
        #
        def log
          msg =  "#{Time.new} - #{self.request_method} #{self.path} - 400 Unauthorized\n"
          msg << "HTTP_AUTHORIZATION: #{self.env['HTTP_AUTHORIZATION']}\n"
          msg << "Auth Message Config: #{@config.request_config[self.request_method]}\n"

          if @allowed_messages
            msg << "Allowed Encrypted Messages:\n"
            @allowed_messages.each do |hash|
              msg << "#{hash}\n"
            end
          end

          msg << "Auth Signature: #{@config.signature}"

          Rack::SimpleAuth::Logger.log(@config.logpath, @config.verbose, ENV['RACK_ENV'], msg)
        end
      end
    end
  end
end
