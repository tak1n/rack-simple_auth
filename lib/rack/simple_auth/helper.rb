module Rack
  module SimpleAuth
    # Helper Module for Gem Helper Methods 
    # which will be used in all AUTH Class files
    module Helper
      class << self
        # Create Digest for specific type and ruby version
        # @param [String] type
        # @return [OpenSSL::Digest|OpenSSL::Digest::Digest] digest
        def digest(type)
          if RUBY_VERSION == "2.1.1"
            OpenSSL::Digest.new(type)
          else
            OpenSSL::Digest::Digest.new(type)
          end
        end
      end
    end
  end
end


