# Rack::SimpleAuth

Rack::SimpleAuth will contain different Authentication Class Middlewares

Until now only HMAC is implemented...

## Installation

Add this line to your application's Gemfile:

    gem 'rack-simple_auth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-simple_auth

## Gem Status

[![Build Status](https://travis-ci.org/Benny1992/rack-simple_auth.png?branch=master)](https://travis-ci.org/Benny1992/rack-simple_auth)
[![Coverage Status](https://coveralls.io/repos/Benny1992/rack-simple_auth/badge.png?branch=master)](https://coveralls.io/r/Benny1992/rack-simple_auth?branch=master)
[![Gem Version](https://badge.fury.io/rb/rack-simple_auth.png)](http://badge.fury.io/rb/rack-simple_auth)
[![Dependency Status](https://gemnasium.com/Benny1992/rack-simple_auth.png)](https://gemnasium.com/Benny1992/rack-simple_auth)
[![Codeship](https://www.codeship.io/projects/f2d9d790-b0fe-0131-3fd5-025f180094b5/status)](https://www.codeship.io/projects/f2d9d790-b0fe-0131-3fd5-025f180094b5/status)

## Usage

### HMAC

To use HMAC Authorization you have to use the ```Rack::SimpleAuth::HMAC::Middleware``` for your Rack App

Basic Usage:
```ruby
  require 'rack/lobster'
  require 'rack/simple_auth'

  request_config = {
    'GET' => 'path',
    'POST' => 'params',
    'DELETE' => 'path',
    'PUT' => 'path',
    'PATCH' => 'path'
  }

  use Rack::SimpleAuth::HMAC::Middleware do |options|
    options.tolerance = 0.5
    options.stepsize  = 0.01

    options.secret = 'test_secret'
    options.signature = 'test_signature'

    options.logpath = "#{File.expand_path('..', __FILE__)}/logs"
    options.request_config = request_config
  end

  run Rack::Lobster.new
```

## Contributing

1. Fork it ( http://github.com/benny1992/rack-simple_auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
