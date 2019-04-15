# frozen_string_literal: true

require "spec_helper"

RSpec.describe Intellimesh::Configuration::HashProvider, "given a simple 2 level configuration" do
  let(:configuration) do
    {
      "amqp" => {
        "broker_url" => broker_url
      },
      "top level key" => top_level_value
    }
  end

  let(:broker_url) { "A BROKER URL" }
  let(:top_level_value) { "A TOP LEVEL VALUE" }

  subject do
    Intellimesh::Configuration::HashProvider.new(configuration)
  end

  it "returns the requested data for the top level key" do
    expect(subject.get(["top level key"], nil, nil, nil)).to eq top_level_value
  end

  it "returns the requested data for the deep key" do
    expect(subject.get(["amqp", "broker_url"], nil, nil, nil)).to eq broker_url
  end
end
