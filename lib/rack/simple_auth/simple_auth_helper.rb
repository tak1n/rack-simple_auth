module Rack
  module SimpleAuth
    module SimpleAuthHelper
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)
      end

      module InstanceMethods
      end

      module ClassMethods
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

        # Method to return Gem Root Dir
        # @return [String] Gem Root Folder
        def root
          ::File.dirname(::File.dirname(::File.expand_path('../..', __FILE__)))
        end
      end
    end
  end
end
