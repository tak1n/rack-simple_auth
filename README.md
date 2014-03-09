# Rack::SimpleAuth

Rack Middleware for HMAC Authentication

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
```Authorization: ContentHash:Signature```

- Signature is the "Public Key"
- ContentHash is the HMAC encrypted Message

#### Use Middleware:

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
You can specify which 'content' will be used for HMAC encryption via the config hash:

For GET and POST params in union use 'params' ('POST' => 'params'):

Post Request with post parameter name = Jon and lastname = Doe

'content' will be:
```ruby
params = {'name' => 'Jon', 'lastname' => 'Doe'}
{ 'method' => 'POST', 'data' => params }.to_json
```

For path encryption use 'path', example:

GET Request to '/'

'content' will be:
```ruby
{ 'method' => 'GET', 'data' => '/' }.to_json
```

Note: Private Key and Signature should be served by a file which is not checked into git version control.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/rack-simple_auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
