# frozen_string_literal: true

module Intellimesh
  module ProcessHost
    module Errors
      class ProcessHostConfigurationError < StandardError; end
      class ProcessHostRunError < RuntimeError; end
    end
  end
end
