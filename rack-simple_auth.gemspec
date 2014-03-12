# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/simple_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-simple_auth"
  spec.version       = Rack::SimpleAuth::VERSION
  spec.authors       = ["Benny1992"]
  spec.email         = ["klotz.benjamin@yahoo.de"]
  spec.summary       = %q{SimpleAuth HMAC authentication}
  spec.description   = spec.summary
  spec.homepage      = "http://www.bennyklotz.at"
  spec.license       = "MIT"

  spec.files = File.read(File.expand_path('../MANIFEST', __FILE__)).split("\n")
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rack-test"
end
