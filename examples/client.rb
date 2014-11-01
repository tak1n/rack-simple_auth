require "net/http"
require "uri"
require 'json'
require 'openssl'

url = URI.parse("http://localhost:9292/")

req = Net::HTTP::Get.new(url.path)

date = (Time.now.to_f * 1000).to_i
message = { 'method' => 'GET', 'date' => date, 'data' => url.path }.to_json
puts message

hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), 'test_secret', message)

req.add_field("AUTHORIZATION", "#{hash}:test_signature")

res = Net::HTTP.new(url.host, url.port).start do |http|
    http.request(req)
end

puts res.body
