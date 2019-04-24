# frozen_string_literal: true

module Intellimesh
  module Configuration
    # Provides the base interface for lookup of configuration settings.
    # Providers need not inherit from this class, but they
    # MUST implement the interface.
    class Provider
      # rubocop:disable Lint/UnusedMethodArgument

      # Get a configuration value from the provider.
      # @param setting [#join, String] the configuration setting to retrieve
      # @param site_name [String] the name of the site
      # @param environment_name [String] the name of the environment
      # @param default [Object, nil] the default value if one is not found
      # @return [Object, nil]
      def get(setting, site_name, environment_name, default = nil)
        raise NotImplementedError, "Subclass Responsibility"
      end

      # rubocop:enable Lint/UnusedMethodArgument
    end
  end
end
