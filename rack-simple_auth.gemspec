# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/simple_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-simple_auth"
  spec.version       = Rack::SimpleAuth::VERSION
  spec.authors       = ["Benny1992"]
  spec.email         = ["r3qnbenni@gmail.com"]
  spec.summary       = %q{SimpleAuth HMAC authentication}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/Benny1992/rack-simple_auth"
  spec.license       = "MIT"

  spec.post_install_message = 'Please report any issues at: ' \
      'https://github.com/Benny1992/rack-simple_auth/issues/new'

  spec.files = File.read(File.expand_path('../MANIFEST', __FILE__)).split("\n")
  spec.require_paths = ["lib"]

  spec.required_ruby_version     = '>= 1.8.7'

  spec.add_runtime_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~>  10.3'
  spec.add_development_dependency "coveralls", '~>  0.7'
  spec.add_development_dependency "rack-test", '~>  0.6'
  spec.add_development_dependency 'minitest', '~> 5.3'
end
