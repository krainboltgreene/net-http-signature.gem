require "spec_helper"

describe Net::HTTP::Signature do
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
  let(:body) { "" }
  let(:secret) { "examplesecret" }
  let(:algorithm) { "hmac-sha512" }
  let(:request) { Net::HTTP::Signature::Request.new(verb: verb, uri: uri, headers: headers, body: body) }
  let(:signer) { Net::HTTP::Signature::Signer.new(request: request, algorithm: algorithm, secret: secret) }
  let(:key) { "examplekey" }
  let(:signature) { described_class.new(signer: signer, key: key) }

  let(:comparison_verb) { verb }
  let(:comparison_uri) { uri }
  let(:comparison_headers) { headers }
  let(:comparison_body) { body }
  let(:comparison_secret) { secret }
  let(:comparison_algorithm) { algorithm }
  let(:comparison_request) { Net::HTTP::Signature::Request.new(verb: comparison_verb, uri: comparison_uri, headers: comparison_headers, body: comparison_body) }
  let(:comparison_signer) { Net::HTTP::Signature::Signer.new(request: comparison_request, algorithm: comparison_algorithm, secret: comparison_secret) }
  let(:comparison_key) { key }
  let(:comparison_signature) { described_class.new(signer: comparison_signer, key: comparison_key) }
  let(:comparison) { comparison_signature.to_h["Signature"] }

  describe "#valid?" do
    let(:valid?) { signature.valid?(comparison) }

    context "with a valid secret" do
      it "returns true" do
        expect(valid?).to be(true)
      end
    end

    context "with an non-same secret" do
      let(:comparison_secret) { "nonexamplesecret" }

      it "returns false" do
        expect(valid?).to be(false)
      end
    end

    context "with an non-same verb" do
      let(:comparison_verb) { "POST" }

      it "returns false" do
        expect(valid?).to be(false)
      end
    end

    context "with non-same body" do
      let(:comparison_body) { "f" }

      it "returns false" do
        expect(valid?).to be(false)
      end
    end

    context "with non-same headers" do
      let(:comparison_headers) do
        {
          "Date" => "2014-10-13 00:48:20 -0500"
        }
      end

      it "returns false" do
        expect(valid?).to be(false)
      end
    end

    context "with non-same uri" do
      let(:comparison_uri) { "http://aii.example.com" }

      it "returns false" do
        expect(valid?).to be(false)
      end
    end

    context "with an invalid string" do
      let(:comparison) { "foobar" }

      it "returns false" do
        expect(valid?).to be(false)
      end
    end
  end

  describe "#to_s" do
    let(:to_s) { signature.to_s }

    it "includes the algorithm" do
      expect(to_s).to include("algorithm=#{algorithm}")
    end

    it "includes the key" do
      expect(to_s).to include("key=#{key}")
    end

    it "includes the token" do
      expect(to_s).to include("token=#{signer}")
    end
  end

  describe "#to_h" do
    let(:to_h) { signature.to_h }

    it "includes the Signature key" do
      expect(to_h.keys).to include("Signature")
    end

    it "includes the string form as a value to Signature key" do
      expect(to_h["Signature"]).to eq(signature.to_s)
    end
  end
end
