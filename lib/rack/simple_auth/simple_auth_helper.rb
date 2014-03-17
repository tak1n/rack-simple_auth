module Rack
  module SimpleAuth
    # Module which contains all Instance and Class Helper Methods
    module SimpleAuthHelper
      # if include SimpelAuthHelper -> extend ClassMethods && include InstanceMethods in Base Module/Class
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)
      end

      # Namespace for InstanceMethods
      module InstanceMethods
      end

      # Namespace for ClassMethods
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
