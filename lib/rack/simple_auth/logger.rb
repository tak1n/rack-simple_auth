module Rack
  module SimpleAuth
    module Logger
      def self.log(logpath, env = 'development', msg)
        open("#{logpath}/#{env}_error.log", 'a') do |f|
          f << "#{msg}\n"
        end

        # Print out log to stdout for dev env
        puts msg if ENV['RACK_ENV'].eql?('development')
      end
    end # Logger
  end # SimpleAuth
end # Rack
