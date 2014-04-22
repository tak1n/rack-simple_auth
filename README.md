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

HMAC should be used for communication between website backend and api server/controller/whatever..

In version 0.0.5 the timestamp has been added to the msg which will be encrypted, also the possibility to configure the allowed delay a request can have has been added.

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
  'tolerance' => 1,
  'steps' => 0.1,
  'signature' => 'signature',
  'secret' => 'secret',
  'logpath' => '/path/to/log/file'
}

map '/' do
  use Rack::SimpleAuth::HMAC, config
  run MyApplication
end
```

Note: Private Key and Signature should be served by a file which is not checked into git version control.





#### Config Hash


Via the config hash you are able to define the 'data' for each request method.<br />
This data + HTTP Methodname is your Message what will be encrypted.<br />

For example ```GET '/get/user?name=rack'```:

```ruby
config = {
    .
    .
  'GET' => 'path'
    .
    .
 }
```

The Message what will be HMAC encrypted is:

```ruby
message = { 'method' => 'GET', 'data' => '/get/user?name=rack' }.to_json
```

In Version 0.0.5 the timestamp has been added to the Message.

The new Message which will be encrypted looks like this:

```ruby
message = { 'method' => 'GET', 'date' => Time.now.to_i +- delay range, 'data' => '/get/user?name=rack }.to_json
```

The tolerance which is configureable in the config hash sets the possible delay a request could have and still will be authorized.

Notice: For a set tolerance a Encrypted Message array will be generated and compared with the MessageHash from the AUTH Header

In Version 0.1.0 the stepsize option has been added

You can now specify how many valid hashes are created in a range between eg.: (-1..1) (= tolerance)

A minimum stepsize of 0.01 is required (0.01 are 10 milliseconds, this is the minimum because of ruby's float disaster and therefore the gem has to use Float#round(2))

Let me know if you need a smaller stepsize...


#### Logging

With config['logpath']  you can define a destination where the internal #log method should write to.

The Logging will only be triggered when a path is defined (leave config['logpath'] for disable logging) and a request is not authorized!

It contains following information:

- HTTP_AUTHORIZATION Header
- Config for the specific Request Method (GET => path etc ...)
- The Encrypted Message Array which was expected
- The Signature which was expected

## TODO 

~~Add Timestamp to encryption..~~

~~For now a sniffer could track a successfull request to the server and extract the HTTP_AUTHORIZATION HEADER for this request.~~

~~He got the encrypted message for the specific request && signature -> No security anymore...~~




## Contributing

1. Fork it ( http://github.com/benny1992/rack-simple_auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request











