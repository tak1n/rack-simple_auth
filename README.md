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
[![GitHub version](https://badge.fury.io/gh/benny1992%2Frack-simple_auth.png)](http://badge.fury.io/gh/benny1992%2Frack-simple_auth)
[![Coverage Status](https://coveralls.io/repos/Benny1992/rack-simple_auth/badge.png?branch=master)](https://coveralls.io/r/Benny1992/rack-simple_auth?branch=master)

## Usage

Uses Authorization HTTP Header, example:
```Authorization: ContentHash:Signature```

Signature is the "Public Key"

ContentHash is the HMAC encrypted Message

```ruby
map '/' do
  use Rack::SimpleAuth::HMAC, 'signature', 'private_key'
  run MyApplication
end```

Private Key and Signature should be served by a file which is not checked into git version control.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/rack-simple_auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
