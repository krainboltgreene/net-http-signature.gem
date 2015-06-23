require "spec_helper"

describe Net::HTTP::Signature::VERSION do
  it "should be a string" do
    expect(Net::HTTP::Signature::VERSION).to be_kind_of(String)
  end
end
