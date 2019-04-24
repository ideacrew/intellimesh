# frozen_string_literal: true

# require File.join(File.dirname(__FILE__), "amqp", "messaging_exchange_topology")
# require File.join(File.dirname(__FILE__), "amqp", "sneakers_extensions")
# require File.join(File.dirname(__FILE__), "amqp", "worker_specification")

module Intellimesh
  module Protocols
    module Amqp
    end
  end
end

module Intellimesh
  module Adapters
    class AmqpAdapter < Adapter

      URI_SCHEME            = :amqp
      EXCHANGE_DEFAULT      = "active_job".freeze
      SERVER_CONFIG_DEFAULT = {
        heartbeat:      10,
        exchange:       'active_job',
        exchange_type:  :direct
      }

      WORKER_CONFIG_DEFAULT = {
        env:                    ENV['RACK_ENV'],  # Environment
        timeout_job_after:      5,                # Maximal seconds to wait for job
        prefetch:               1,                # Grab 10 jobs together. Better speed.
        threads:                1,                # Threadpool size (good to match prefetch)
        durable:                true,             # Is queue durable?
        ack:                    true,             # Must we acknowledge?
        heartbeat:              2,                # Keep a good connection with broker
        exchange:               EXCHANGE_DEFAULT, # AMQP exchange
        hooks:                  {},               # prefork/postfork hooks
        start_worker_delay:     10,               # Delay between thread startup

        retry_exchange:         'activejob-retry',
        retry_error_exchange:   'activejob-error',
        retry_requeue_exchange: 'activejob-retry-requeue'
      }

      attr_accessor :worker_count, :handler, :pid_file_location

      def initialize(pid_file_location, worker_count = 4, handler = nil)
        @pid_file_location = pid_file_location
        @handler = handler
        @worker_count = worker_count
      end

      # Set up RabbitMQ Connection
      def default_server_config
        Sneakers.configure(
            amqp:           'amqp://guest:guest@localhost:5672',
            vhost:          '/',
            pid_path:       @pid_file_location,
            workers:        @worker_count
          )
        Sneakers.logger_level = Logger::INFO
        Sneakers.error_reporters << proc { |exception, _worker, context_hash| Honeybadger.notify(exception, context_hash) }
        Sneakers
      end

      def default_global_worker_config
        {
        }
      end

      def default
      end
    end
  end
end
