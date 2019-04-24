# frozen_string_literal: true

require "spec_helper"

RSpec.describe "An AMQP Reply URI" do
  let(:exchange_type) { "direct" }
  let(:exchange_name) { "my_direct_exchange" }
  let(:routing_key) { "some.routing.key" }
  let(:uri) { "amqpreply://#{exchange_type}@#{exchange_name}/#{routing_key}" }

  subject { URI.parse(uri) }

  it "has the correct protocol type" do
    expect(subject.kind_of?(::URI::AMQPReply)).to be_truthy
  end

  it "has the correct exchange name" do
    expect(subject.exchange_name).to eq exchange_name
  end

  it "has the correct exchange type" do
    expect(subject.exchange_type).to eq exchange_type
  end

  it "has the correct routing key" do
    expect(subject.routing_key).to eq routing_key
  end
end