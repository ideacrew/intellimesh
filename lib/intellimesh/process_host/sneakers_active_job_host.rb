# frozen_string_literal: true

module Intellimesh
  module ProcessHost
    # Spawns and manages sneakers workers which take work from ActiveJob.
    class SneakersActiveJobHost
      def self.run(
          configuration_provider,
          sneakers_configuration
        )
        ::Intellimesh::Configuration.provider = configuration_provider
        # rubocop:disable Lint/RescueException
        begin
          sneakers_configuration.apply
        rescue Exception => e
          raise ::Intellimesh::ProcessHost::Errors::ProcessHostConfigurationError, e
        end
        runner = Sneakers::Runner.new([ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper])
        begin
          runner.run
        rescue Exception => e
          raise ::Intellimesh::ProcessHost::Errors::ProcessHostRunError, e
        end
        # rubocop:enable Lint/RescueException
      end
    end
  end
end
