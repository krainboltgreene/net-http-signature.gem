require "spec_helper"

describe Net::HTTP::Signature::Request do
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
  let(:request) { described_class.new(verb: verb, uri: uri, headers: headers, body: body) }

  context "with an missing Date header" do
    let(:headers) do
      {
        "Host" => "api.example.com",
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "Authentication" => "Bearer fas425fmig.idfiodf"
      }
    end

    it "raises an error" do
      expect { request }.to raise_error(ArgumentError)
    end
  end

  describe "#to_s" do
    let(:to_s) { request.to_s }

    it "includes the verb" do
      expect(to_s).to include(verb)
    end

    it "includes the uri" do
      expect(to_s).to include(uri)
    end

    it "includes the headers" do
      expect(to_s).to include(headers.to_a.sort_by(&:first).map { |(key, value)| "#{key}: #{value}" }.join("\n"))
    end

    it "includes the body" do
      expect(to_s).to include(body)
    end
  end
end
