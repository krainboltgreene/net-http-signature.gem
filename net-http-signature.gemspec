#!/usr/bin/env ruby
# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "net/http/signature/version"

Gem::Specification.new do |spec|
  spec.name          = "net-http-signature"
  spec.version       = Net::HTTP::Signature::VERSION
  spec.authors       = ["Kurtis Rainbolt-Greene"]
  spec.email         = ["kurtis@rainbolt-greene.online"]
  spec.summary       = %q{A signing library for HTTP requests}
  spec.description   = spec.summary
  spec.homepage      = "http://krainboltgreene.github.io/net-http-signature"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"]
  spec.executables   = Dir["bin/**/*"].map! { |f| f.gsub(/bin\//, "") }
  spec.test_files    = Dir["test/**/*", "spec/**/*"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "pry", "~> 0.9"
  spec.add_development_dependency "pry-doc", "~> 0.6"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4"
end
