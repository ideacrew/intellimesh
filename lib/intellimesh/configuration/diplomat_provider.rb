# frozen_string_literal: true

require 'diplomat'

module Intellimesh
  module Configuration
    # Configuration provider using Diplomat KV store.
    class DiplomatProvider
      def initialize(
          diplomat_url,
          consul_token,
          diplomat_module = ::Diplomat,
          diplomat_kv = ::Diplomat::Kv
        )
        @diplomat_module = diplomat_module
        @diplomat_module.configure do |config|
          # Set up a custom Consul URL
          config.url = diplomat_url
          # Set extra Faraday configuration options and custom access token (ACL)
          config.options = {
            headers: {
              "X-Consul-Token" => consul_token
            }
          }
        end
        @diplomat_kv = diplomat_kv
      end

      # Get a configuration value from diplomat.
      # @param setting [#join, String] the configuration setting to retrieve
      # @param tenant_name [String] the name of the tenant
      # @param environment_name [String] the name of the environment
      # @param default [Object, nil] the default value if one is not found
      # @return [Object, nil]
      def get(setting, tenant_name, environment_name, default = nil)
        j_setting = setting.respond_to?(:join) ? setting.join("/") : setting
        s_name = [tenant_name, environment_name, j_setting].join("/")
        @diplomat_kv.get(s_name) || default
      end
    end
  end
end
