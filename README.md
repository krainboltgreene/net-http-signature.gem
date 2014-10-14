net-http-signature
------------------

  - [![Version](https://badge.fury.io/rb/net-http-signature.png)](https://rubygems.org/gems/net-http-signature)
  - [![Climate](https://codeclimate.com/github/krainboltgreene/net-http-signature.gem.png)](https://codeclimate.com/github/krainboltgreene/net-http-signature.gem)
  - [![Build](http://img.shields.io/travis-ci/krainboltgreene/net-http-signature.gem.png)](https://travis-ci.org/krainboltgreene/net-http-signature.gem)
  - [![Dependencies](https://gemnasium.com/krainboltgreene/net-http-signature.gem.png)](https://gemnasium.com/krainboltgreene/net-http-signature.gem)
  - [![License](http://img.shields.io/license/MIT.png?color=green)](http://opensource.org/licenses/MIT)

This library gives you an interface for signing and validating HTTP requests/responses.


Using
=====

First lets assume we start from the consumer client. In this case we'll need to start with some request values:

``` ruby
require "net/http/signature"

verb = "GET"
uri = "http://google.com?a=1&b=2"
headers = {
  "Date" => Time.now,
  "Content-Type" => "application/json",
  "Accept" => "application/json",
  "Authentication" => "Bearer fas425fmig.idfiodf"
}
body = ""

request = Net::HTTP::Signature::Request.new(verb: verb, uri: uri, headers: headers, body: body)
```

The headers must include Date and cannot include Signature.

Next we'll need to build a signer, the encrpytion:

``` ruby
secret = "foozlebufzzle"
algorithm = "hmac-sha512"

signer = Net::HTTP::Signature::Signer.new(request: request, secret: secret, algorithm: algorithm)
```

The secret is the consumer secret for the API. Similar to a user's password.

Finally we need to build the signature:

``` ruby
key = "krainboltgreene"

signature = Net::HTTP::Signature.new(key: key, signer: signer)
```

The key in this case is the consumer key for the API. Similar to a user's username or email.

You can now turn this into a header key/value:

``` ruby
signature.to_h
  # =>
  #   {
  #     "Signature" => "key=krainboltgreene algorithm=hmac-sha512 headers=Date,Content-Type,Accept token=06MNzV00902BKawOL5UwhKf9hJUR97RizAtyr6+xhwF94ne0/Uz/MTRRDrJQ\nLdfHyBuuuXEMVYeg24xDcsTaFA==\n"
  #   }
```

You would take this hash and merge it into the request's headers, sending to the server. The API server would consume the request, extract the `"Signature"` pair, and do the above steps. For the server to complete the steps you need to also take the `key` value of the `Signature` header and look up the consumer secret.

If the consumer key exists in your system and the `Net::HTTP::Signature` object is built with that discovered consumer secret you can proceed to validate the request.

To validate you  need call the `Net::HTTP::Signature#valid?` method:

``` ruby
signature.valid?(request_headers["Signature"])
  # => true
```

If the return is true then you should make sure the request's `Date` header is within a 6 second window. This will prevent attackers from being able to indefinitely use requests they've obtained.


Installing
==========

Add this line to your application's Gemfile:

    gem "net-http-signature", "~> 1.0"

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install net-http-signature


Contributing
============

  1. Fork it
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create new Pull Request


Licensing
=========

Copyright (c) 2013 Kurtis Rainbolt-Greene

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
