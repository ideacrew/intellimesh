# frozen_string_literal: true

require "sneakers"
require "sneakers/runner"
require "sneakers/handlers/maxretry"
require "serverengine"

module Intellimesh
  module ProcessHost
    module ProcessPerWorkerWorkerGroup
      include ::Sneakers::WorkerGroup

      def run
        after_fork

        # Allocate single thread pool if share_threads is set. This improves load balancing
        # when used with many workers.
        pool = config[:share_threads] ? Concurrent::FixedThreadPool.new(config[:threads]) : nil

        worker_classes = config[:worker_classes]

        if worker_classes.respond_to? :call
          worker_classes = worker_classes.call
        end

        # If we don't provide a connection to a worker,
        # the queue used in the worker will create a new one

        worker_class = worker_classes[@worker_id]

        @workers = [
          worker_class.new(nil, pool, { connection: config[:connection] })
        ]

        # if more than one worker this should be per worker
        # accumulate clients and consumers as well
        @workers.each(&:run!)
        # end per worker
        #
        until @stop_flag.wait_for_set(Sneakers::CONFIG[:amqp_heartbeat])
          Sneakers.logger.debug("Heartbeat: running threads [#{Thread.list.count}]")
          # report aggregated stats?
        end
      end
    end

    class OneWorkerPerProcessRunner < ::Sneakers::Runner
      def initialize(worker_classes, opts = {})
        super(worker_classes, opts)
        @worker_count = worker_classes.length
      end

      def run
        @se = ::ServerEngine.create(nil, ::Intellimesh::ProcessHost::ProcessPerWorkerWorkerGroup) do
           reload_runner_config!
        end
        @se.run
      end

      def reload_runner_config!
        @runnerconfig.reload_config!.merge(
          {
            :workers => @worker_count
          }
        )
      end
    end

    # Spawns and restarts sneakers workers using forked processes and shared memory,
    # acting as the host service for a set of configured sneakers workers.
    #
    # This host is used to manage the lifecycle of workers who participate in pub/sub
    # based sneakers worker behaviour.
    class SneakersWorkerHost
      def self.run(
        configuration_provider,
        sneakers_configuration
      )
        ::Intellimesh::Configuration.provider = configuration_provider
        worker_classes = [] # Resolved below
        sneakers_configuration.handler = ::Sneakers::Handlers::Maxretry
        sneakers_configuration.worker_count = worker_classes.length
        # rubocop:disable Lint/RescueException
        begin
          sneakers_configuration.apply
          ensure_messaging_exchanges
          worker_classes = ::Intellimesh::Protocols.resolve_amqp_worker_list!
        rescue Exception => e
          raise ::Intellimesh::ProcessHost::Errors::ProcessHostConfigurationError, e
        end
        runner = ::Intellimesh::ProcessHost::OneWorkerPerProcessRunner.new(worker_classes)
        begin
          runner.run
        rescue Exception => e
          raise ::Intellimesh::ProcessHost::Errors::ProcessHostRunError, e
        end
        # rubocop:enable Lint/RescueException
      end

      def self.ensure_messaging_exchanges(sneakers_config)
        ::Intellimesh::Protocols::Amqp::MessagingExchangeTopology.ensure_topology_exists(sneakers_config.amqp)
      end
    end
  end
end
