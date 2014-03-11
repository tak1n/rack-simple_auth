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

## Usage

### HMAC Authorization

Uses Authorization HTTP Header, example:
```Authorization: MessageHash:Signature```

- Signature is the "Public Key"
- MessageHash is the HMAC encrypted Message

#### Basic Usage:

```ruby
config = {
  'GET' => 'path',
  'POST' => 'params',
  'DELETE' => 'path',
  'PUT' => 'path',
  'PATCH' => 'path'
}

map '/' do
  use Rack::SimpleAuth::HMAC, 'signature', 'private_key', config
  run MyApplication
end
```

Note: Private Key and Signature should be served by a file which is not checked into git version control.

#### Config Hash

Via the config hash you are able to define the 'data' for each request method.<br />
This data + HTTP Methodname is your Message what will be encrypted.<br />

For example ```GET '/get/user?name=rack'```:

```ruby
config = { 'GET' => 'path' }
```

The Message what will be HMAC encrypted is:

```ruby
message = { 'method' => 'GET', 'data' => '/get/user?name=rack' }.to_json
```




## Contributing

1. Fork it ( http://github.com/benny1992/rack-simple_auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request






