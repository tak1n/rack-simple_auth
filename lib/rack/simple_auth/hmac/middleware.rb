module Rack
  module SimpleAuth
    # Contains different classes for authorizing against a hmac signed request
    module HMAC
      ##
      # Middleware class which represents the interface to the rack api via {#call}
      # and checks if a request is hmac authorized.
      #
      # @example Basic Usage
      #   "request_config = {
      #      'GET' => 'path',
      #      'POST' => 'params',
      #      'DELETE' => 'path',
      #      'PUT' => 'path',
      #      'PATCH' => 'path'
      #    }
      #
      #    use Rack::SimpleAuth::HMAC::Middleware do |options|
      #      options.tolerance = 1500
      #
      #      options.secret = 'test_secret'
      #      options.signature = 'test_signature'
      #
      #      options.logpath = "#{File.expand_path('..', __FILE__)}/logs"
      #      options.request_config = request_config
      #
      #      options.verbose = true
      #    end
      #
      #    run Rack::Lobster.new"
      #
      class Middleware
        ##
        # Constructor for Rack Middleware (passing the rack stack)
        #
        # @param [Rack Application] app [next middleware or rack app which gets called]
        #
        def initialize(app)
          @app, @config = app, Config.new

          yield @config if block_given?
        end

        ##
        # Rack API Interface Method
        #
        # @param [Hash] env [Rack Env Hash which contains headers etc..]
        #
        def call(env)
          # self.dup.call!(env)
          dup.call!(env)
        end

        ##
        # call! Method
        #
        # @param [Hash] env [Rack Env Hash which contains headers etc..]
        #
        def call!(env)
          env = env.dup
          request = Request.new(env, @config)

          if request.valid?
            @app.call(env)
          else
            response = Response.new('Unauthorized', 401, 'Content-Type' => 'text/html')
            response.finish
          end
        end
      end # Middleware
    end # HMAC
  end # SimpleAuth
end # Rack
