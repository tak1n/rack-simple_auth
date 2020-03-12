# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/simple_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-simple_auth"
  spec.version       = Rack::SimpleAuth::VERSION
  spec.authors       = ["Benny Klotz"]
  spec.email         = ["benny.klotz92@gmail.com"]
  spec.summary       = %q{SimpleAuth HMAC authentication}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/tak1n/rack-simple_auth"
  spec.license       = "MIT"

  spec.post_install_message = 'Please report any issues at: ' \
      'https://github.com/tak1n/rack-simple_auth/issues/new'

  spec.files = File.read(File.expand_path('../MANIFEST', __FILE__)).split("\n")
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.5.7'
  spec.add_runtime_dependency 'rack', '~> 2.2'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rack-test', '~> 1.1'
  spec.add_development_dependency 'minitest', '~> 5.14'
  spec.add_development_dependency 'minitest-reporters', '~> 1.4'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rubocop', '~> 0.80'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
end
