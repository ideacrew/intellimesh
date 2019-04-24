# frozen_string_literal: true

require "spec_helper"

RSpec.describe Intellimesh::Configuration::DiplomatProvider, "given a configuration" do
  let(:diplomat_uri) { "A DIPLOMAT URI" }
  let(:consul_token) { "A CONSUL TOKEN" }

  let(:diplomat_config) do
    instance_double(::Diplomat::Configuration)
  end

  let(:diplomat_module) do
    class_double(::Diplomat)
  end

  subject do
    @subject = Intellimesh::Configuration::DiplomatProvider.new(
      diplomat_uri,
      consul_token,
      diplomat_module
    )
  end

  before :each do
    allow(diplomat_module).to receive(:configure).and_yield(diplomat_config)
    allow(diplomat_config).to receive(:url=).with(diplomat_uri)
    allow(diplomat_config).to receive(:options=).with(
      {
        headers: {
          "X-Consul-Token" => consul_token
        }
      }
    )
  end

  it "configures diplomat with the correct uri" do
    expect(diplomat_config).to receive(:url=).with(diplomat_uri)
    Intellimesh::Configuration::DiplomatProvider.new(
      diplomat_uri,
      consul_token,
      diplomat_module
    )
  end

  it "configures diplomat with the correct token" do
    expect(diplomat_config).to receive(:options=).with(
      {
        headers: {
          "X-Consul-Token" => consul_token
        }
      }
    )
    Intellimesh::Configuration::DiplomatProvider.new(
      diplomat_uri,
      consul_token,
      diplomat_module
    )
  end
end

RSpec.describe Intellimesh::Configuration::DiplomatProvider, "given a simple 2 level configuration" do
  let(:broker_url) { "A BROKER URL" }
  let(:site_name) { "A TENANT NAME" }
  let(:environment_name) { "AN ENVIRONMENT NAME" }
  let(:diplomat_uri) { "A DIPLOMAT URI" }
  let(:consul_token) { "A CONSUL TOKEN" }

  let(:diplomat_config) do
    instance_double(::Diplomat::Configuration)
  end

  let(:diplomat_module) do
    class_double(::Diplomat)
  end

  subject do
    @subject = Intellimesh::Configuration::DiplomatProvider.new(
      diplomat_uri,
      consul_token,
      diplomat_module
    )
  end

  before :each do
    allow(diplomat_module).to receive(:configure).and_yield(diplomat_config)
    allow(diplomat_config).to receive(:url=).with(diplomat_uri)
    allow(diplomat_config).to receive(:options=).with(
      {
        headers: {
          "X-Consul-Token" => consul_token
        }
      }
    )
    allow(::Diplomat::Kv).to receive(:get).with(
      [site_name, environment_name, "amqp", "broker_url"].join("/")
    ).and_return(broker_url)
  end

  it "returns the requested data" do
    expect(subject.get(["amqp", "broker_url"], site_name, environment_name)).to eq broker_url
  end
end
