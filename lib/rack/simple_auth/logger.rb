module Rack
  module SimpleAuth
    # class Logger
    # This class receives a logpath, env and message and
    # prints the message to the specified logpath for the proper env file (eg.: /path/to/file/test_error.log for test env)
    module Logger
      def self.log(logpath, env = 'development', msg)
        system("mkdir #{logpath}") unless Dir.exist?("#{logpath}")
        open("#{logpath}/#{env}_error.log", 'a') do |f|
          f << "#{msg}\n"
        end

        # Print out log to stdout for dev env
        puts msg if ENV['RACK_ENV'].eql?('development')
      end
    end # Logger
  end # SimpleAuth
end # Rack
