# frozen_string_literal: true

require "spec_helper"

RSpec.describe Intellimesh::Addresses::AmqpAddress do

  let(:uri_scheme)  { "amqp" }
  let(:uri_min)     { URI::parse("#{uri_scheme}://") }

  context "When an address is initialized without parameters" do
    subject { described_class.new() }

    it "the URI scheme component should have a default value" do
      expect(subject.scheme).to eq uri_scheme
    end

    it "and the URI query component string should be_nil" do
      expect(subject.query).to be_nil
    end

    it "and the #to_uri method should return throw an ArgumentError" do
      # expect{subject.to_uri}.to raise_error(ArgumentError)
      expect(subject.to_uri).to eq uri_min
    end
  end

  context "When an address is initialized with minimum required parameters" do

    let(:exchange_name) { "exchange_name_value" }
    let(:queue_name)    { "queue_name_value" }
    let(:uri)           { URI::parse("#{uri_scheme}://#{exchange_name}/#{queue_name}")}


    it "to_uri method should return a valid URI" do
      expect(described_class.new(exchange_name: exchange_name, queue_name: queue_name).to_uri).to eq uri
    end
  end

  context "When an address is initialized with all URI components except query" do
    let(:exchange_name) { "exchange_name_value" }
    let(:queue_name)    { "queue_name_value" }
    let(:userinfo)      { "userinfo_value" }
    let(:routing_key)   { "routing_key_value" }
    let(:exchange_type) { "exchange_type_value" }
    let(:port)          { 666 }
    let(:uri_max)       { URI::parse("#{uri_scheme}://#{userinfo}@#{exchange_name}:#{port}/#{queue_name}?routing_key=#{routing_key}?exchange_type=#{exchange_type}")}

    it "to_uri method should return a valid URI" do
      expect(described_class.new(
                                    exchange_name: exchange_name, 
                                    queue_name: queue_name, 
                                    userinfo: userinfo, 
                                    port: port, 
                                    routing_key: routing_key, 
                                    exchange_type: exchange_type,
                                  ).to_uri).to eq uri_max
    end
  end

end
