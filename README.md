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
  use Rack::SimpleAuth::HMAC, 'signature', 'private_key', config, '/path/to/log/file'
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

#### Logging

With the 4th parameter for Rack::SimpleAuth::HMAC you can define a destination where the internal #log method should write to.

The Logging will only be triggered when a path is defined (leave 4th param for disable logging) and a request is not authorized!

It contains following information:

- HTTP_AUTHORIZATION Header
- Config for the specific Request Method (GET => path etc ...)
- The Encrypted Message which was expected
- The Signature which was expected

## TODO 

Add Timestamp to encryption..

For now a sniffer could track a successfull request to the server and extract the HTTP_AUTHORIZATION HEADER for this request.

He got the encrypted message for the specific request && signature -> No security anymore...

## Contributing

1. Fork it ( http://github.com/benny1992/rack-simple_auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
