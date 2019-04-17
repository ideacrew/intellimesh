# frozen_string_literal: true

require File.join(File.dirname(__FILE__), "protocols", "amqp")
require File.join(File.dirname(__FILE__), "protocols", "worker_specification")

module Intellimesh
  module Protocols
    # @!visibility private
    class SneakersWorkerRegistry
      # rubocop:disable Style/ClassVars
      def initialize
        return if defined?(@@worker_specs)

        @@worker_specs = []
      end

      def add_worker_spec(const_str)
        @@worker_specs << const_str
      end

      def worker_specs
        @@worker_specs
      end

      def resolve_amqp_worker_list!
        @@worker_specs.map do |ws|
          kls = ws.constantize
          klass_worker_spec = kls.worker_specification
          klass_worker_spec.protocol_worker_specification.execute_sneakers_config_against(
            kls
          )
          kls
        end
      end
      # rubocop:enable Style/ClassVars
    end

    module Config
      def amqp_workers_registry
        Thread.current[:_i_mesh_protocols_amqp_worker_registry] ||= SneakersWorkerRegistry.new
      end

      def register_amqp_worker(const_str)
        amqp_workers_registry.add_worker_spec(const_str)
      end

      def resolve_amqp_worker_list!
        amqp_workers_registry.resolve_amqp_worker_list!
      end
    end

    extend Config
  end
end
