# frozen_string_literal: true

require "spec_helper"

RSpec.describe Intellimesh::Configuration, "given no provider" do
  it "raises an error on #get" do
    expect { Intellimesh::Configuration.get("abkejcsdkljlkerf") }.to(
      raise_error(Intellimesh::Configuration::Errors::NoProviderSpecifiedError)
    )
  end
end
