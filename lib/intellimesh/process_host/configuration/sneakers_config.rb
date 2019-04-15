# frozen_string_literal: true

require "sneakers/handlers/maxretry"

module Intellimesh
  module ProcessHost
    module Configuration
      # Encapsulates and provides indirection for sneakers global settings.
      # Allows us to get the settings from anywhere - from a managed
      # configuration KV store to being supplied directly in code.
      class SneakersConfiguration
        # Apply the configuration.

        def initialize(pid_file_location, handler = nil, worker_count = 1)
          @pid_file_location = pid_file_location
          @handler = handler
          @worker_count = worker_count
        end

        def apply
          Sneakers.configure(
            to_sneakers_parameters
          )
        end

        def amqp
          ::Intellimesh::Configuration.get(["amqp", "broker_uri"])
        end

        protected

        def to_sneakers_parameters
          configuration = {
            :heartbeat => 15,
            :amqp => amqp,
            :log => STDOUT,
            :ack => true,
            :timeout_job_after => 86400,
            :retry_max_times => 5,
            :retry_timeout => 5000,
            :pid_path => @pid_file_location,
            :workers => @worker_count
          }
          configuration.merge({ :handler => @handler }) if @handler
          configuration
        end
      end
    end
  end
end
