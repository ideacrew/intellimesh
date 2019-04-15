# frozen_string_literal: true

require "spec_helper"

RSpec.describe Intellimesh::Loggable do
  describe "#logger=" do
    let(:logger) do
      Logger.new($stdout).tap do |log|
        log.level = Logger::INFO
      end
    end

    before do
      Intellimesh.logger = logger
    end

    it "sets the logger" do
      expect(Intellimesh.logger).to eq(logger)
    end
  end
end
