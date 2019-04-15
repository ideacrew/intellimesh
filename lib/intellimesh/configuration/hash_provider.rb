# frozen_string_literal: true

module Intellimesh
  module Configuration
    # Configuration provider using a simple hash.
    # You will most likely use this for testing.
    class HashProvider
      def initialize(options = {})
        @config = options
      end

      # Get a configuration value from the hash.
      # @param setting [#join, String] the configuration setting to retrieve
      # @param _tenant_name [String] the name of the tenant
      # @param _environment_name [String] the name of the environment
      # @param default [Object, nil] the default value if one is not found
      # @return [Object, nil]
      def get(setting, _tenant_name, _environment_name, default = nil)
        @config.dig(*setting) || default
      end
    end
  end
end
