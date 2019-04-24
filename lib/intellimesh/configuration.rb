# frozen_string_literal: true

require File.join(File.dirname(__FILE__), "configuration", "errors")
require File.join(File.dirname(__FILE__), "configuration", "provider")
require File.join(File.dirname(__FILE__), "configuration", "hash_provider")
require File.join(File.dirname(__FILE__), "configuration", "diplomat_provider") if defined?(Diplomat)

module Intellimesh
  module Configuration
    # @!visibility private
    class Core
      # rubocop:disable Style/ClassVars

      def initialize
        return if defined?(@@site_name)

        @@site_name = nil
        @@environment_name = nil
      end

      def site_name=(t_name)
        @@site_name = t_name
      end

      def site_name
        @@site_name
      end

      def environment_name=(e_name)
        @@environment_name = e_name
      end

      def environment_name
        @@environment_name
      end
      # rubocop:enable Style/ClassVars
    end

    # @!visibility private
    class Backend
      # rubocop:disable Style/ClassVars

      def initialize
        return if defined?(@@provider)

        @@provider = nil
      end

      def provider=(prov)
        @@provider = prov
      end

      def provider
        @@provider
      end
      # rubocop:enable Style/ClassVars
    end

    module Base
      # @!visibility private
      def backend
        Thread.current[:_i_mesh_task_fabric_config] ||= Backend.new
      end

      # @!visibility private
      def core
        Thread.current[:_i_mesh_task_fabric_core_config] ||= Core.new
      end

      def provider=(prov)
        backend.provider = prov
      end

      def site_name=(t_name)
        core.site_name = t_name
      end

      def site_name
        core.site_name
      end

      def environment_name=(e_name)
        core.environment_name = e_name
      end

      def environment_name
        core.environment_name
      end

      # Get a configuration value.
      # @param setting [#join, String] the configuration setting to retrieve
      # @param default [Object, nil] the default value if one is not found
      # @return [Object, nil]
      def get(setting, default = nil)
        prov = backend.provider
        raise Errors::NoProviderSpecifiedError unless prov

        prov.get(setting, site_name, environment_name, default)
      end
    end

    extend Base
  end
end
