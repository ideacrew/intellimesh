# frozen_string_literal: true

module Intellimesh
  module Workers
    class Worker
      include Sneakers::Worker
      include Intellimesh::Configuration::AmqpSneakersConfiguration

      DEFAULT_EXCHANGE_NAME   = :default
      DEFAULT_PID_PATH        = 'sneakers.pid'
      DEFAULT_ERROR_REPORTERS = [Sneakers::ErrorReporter::DefaultLogger.new]
      DEFAULT_ENVIRONMENT     = ENV['RACK_ENV']

      attr_reader :worker_name, :pid_path, :exchange_name, :logger, :environment

      # Singleton Adapter for AMQP connection
      # def adapter=(amqp_adapter); end

      def initialize(worker_name:, options: {})
        @worker_name      = worker_name

        @exchange_name    = options[:exchange_name].to_sym || DEFAULT_EXCHANGE_NAME
        @pid_path         = options[:pid_path] || DEFAULT_PID_PATH
        @error_reporters  = options[:error_reporters] || DEFAULT_ERROR_REPORTERS
        @logger           = options[:logger] || DEFAULT_LOGGER
        @environment      = options[:environment] || DEFAULT_ENVIRONMENT
      end

      # Module Sneakers::Worker
      # Class methods
      #   #included(base)
      # Instance Methods
      #   #initialize(queue, pool, opts)
      #   #ack!
      #   #do_work(delivery_info, metadata, msg, handler)
      #   #log_msg(msg)
      #   #publish(msg, opts)
      #   #reject!
      #   #requeue!
      #   #run
      #   #stop
      #   #worker_error(msg, exception)
      #   #worker_trace(msg)

      # Module Sneakers::Worker::ClassMethods
      # In more advanced scenarios you would be able to mix in components of a worker into your own worker class
      # Instance methods
      #   #enqueue(msg)
      #   #from_queue(q, opts = {})


      def all_command_options
        hashes_merge([error_reporters, command_runner_options, command_worker_options])
      end

      def command_worker_options
        {
          :prefetch           => 1,
          :threads            => 10,
          :share_threads      => false,
          :ack                => true,
          :heartbeat          => 1,
          :hooks              => {},
          :exchange           => exchange_name,
          :exchange_options   => command_exchange_options,
          :queue_options      => command_queue_options
        }
      end

      def command_runner_options
        {
          :runner_config_file => nil,
          :metrics            => nil,
          :daemonize          => false,
          :start_worker_delay => 0,
          :workers            => 4,
          :log                => logger,
          :pid_path           => pid_path,
          :amqp_heartbeat     => 1,
        }
      end

      def command_exchange_options
        {
          :type               => :direct,
          :durable            => true,
          :auto_delete        => false,
          :arguments => {} # Passed as :arguments to Bunny::Channel#exchange
        }
      end

      def command_queue_options
        {
          :durable            => true,
          :auto_delete        => false,
          :exclusive          => false,
          :arguments => {}
        }
      end

      def error_reporters
        {
          # Set up default handler which just logs the error.
          # Remove this in production if you don't want sensitive data logged.
          :error_reporters => error_reporters,
        }
      end

      # Local (per worker)
      def command_local_worker_options
        {
          # kind: ServiceRequestSubscriber,
          # from_queue: :member_address_change_fa43670,
          :env                => environment,
          :prefetch           => command_worker_options[:prefetch],
          :threads            => command_worker_options[:threads],
          :ack                => command_worker_options[:ack],
          :heartbeat          => command_worker_options[:hearbeat],
          :hooks              => command_worker_options[:hooks],
          :exchange           => command_worker_options[:exchange],

          # Command Runner options
          :start_worker_delay => command_runner_options[:start_worker_delay],

          # Command Exchange options
          :durable            => command_exchange_options[:durable],
          :timeout_job_after  => command_exchange_options[:timeout_job_after],

          :retry_exchange         => retry_exchange_name_for(exchange_name),
          :retry_error_exchange   => retry_error_exchange_name_for(exchange_name),
          :retry_requeue_exchange => requeue_exchange_name_for(exchange_name),
        }
      end

      private

      def generate_service_script
      end

      def hash_merge(hashes)
        hashes.inject(:merge)
      end

      def retry_exchange_name_for(name)
        exchange_name + '-retry'
      end

      def retry_error_exchange_name_for(name)
        exchange_name + '-error'
      end

      def requeue_exchange_name_for(name)
        exchange_name + '-retry-requeue'
      end


    end
  end
end
