module Rack
  module SimpleAuth
    # class Logger
    # This class receives a logpath, env and message and
    # prints the message to the specified logpath for the proper env file (eg.: /path/to/file/test_error.log for test env)
    module Logger
      # Create Logfile
      #
      # @param [String] logpath [path to logfile]
      # @param [TrueClass|FalseClass] verbose [if true print to stdout]
      # @param [String] msg [Message defined by each Authorization class]
      #
      def self.log(logpath, verbose = false, env, msg)
        system("mkdir #{logpath}") unless Dir.exist?("#{logpath}")
        open("#{logpath}/#{env}_error.log", 'a') do |f|
          f << "#{msg}\n"
        end

        puts msg if verbose
      end
    end # Logger
  end # SimpleAuth
end # Rack
