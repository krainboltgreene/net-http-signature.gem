require "spec_helper"

describe Net::HTTP::Signature::Signer do
  let(:verb) { "GET" }
  let(:uri) { "http://api.example.com" }
  let(:headers) do
    {
      "Host" => "api.example.com",
      "Date" => "2014-10-13 00:48:28 -0500",
      "Content-Type" => "application/json",
      "Accept" => "application/json",
      "Authentication" => "Bearer fas425fmig.idfiodf"
    }
  end
  let(:body) { "examplebody" }
  let(:request) { Net::HTTP::Signature::Request.new(verb: verb, uri: uri, headers: headers, body: body) }
  let(:digester) { "hmac" }
  let(:sha) { "sha512" }
  let(:algorithm_name) { "#{digester}-#{sha}" }
  let(:secret) { "foo" }
  let(:signer) { described_class.new(request: request, algorithm: algorithm_name, secret: secret) }

  context "with an invalid digester" do
    let(:algorithm_name) { "example-sha512" }

    it "raises an error" do
      expect { signer }.to raise_error(ArgumentError)
    end
  end

  context "with an invalid sha" do
    let(:algorithm_name) { "hmac-sha666" }

    it "raises an error" do
      expect { signer }.to raise_error(RuntimeError)
    end
  end

  context "with an invalid algorithm name" do
    let(:algorithm_name) { "hmac sha512" }

    it "raises an error" do
      expect { signer }.to raise_error(ArgumentError)
    end
  end

  describe "#algorithm" do
    let(:algorithm) { signer.algorithm }

    it "includes the digester" do
      expect(algorithm).to include(digester)
    end

    it "includes the sha" do
      expect(algorithm).to include(sha)
    end
  end

  describe "#to_s" do
    let(:to_s) { signer.to_s }
    let(:signature) { OpenSSL.const_get(digester.upcase).digest(sha, secret, request.to_s) }
    let(:encoded_signature) { Base64.encode64(signature) }

    it "includes the base64'd signature token" do
      expect(to_s).to eq(encoded_signature)
    end
  end
end
