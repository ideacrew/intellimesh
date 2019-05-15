# frozen_string_literal: true

require 'sneakers'
require 'active_support'

module Intellimesh
  module Configuration
    module AmqpSneakersConfiguration
      extend ActiveSupport::Concern

      included do
        WORKER_OPTIONS  = %w[prefetch threads share_threads ack heartbeat hooks exchange exchange_options queue_options].freeze
        WORKER_KEYS     = WORKER_OPTIONS.reduce([]) { |list, option| list << option.to_sym }.freeze

        RUNNER_OPTIONS  = %w[runner_config_file metrics daemonize start_worker_delay workers log pid_path amqp_heartbeat].freeze
        RUNNER_KEYS     = RUNNER_OPTIONS.reduce([]) { |list, option| list << option.to_sym }.freeze

        EXCHANGE_KEYS   = EXCHANGE_OPTION_DEFAULTS.keys
        QUEUE_KEYS      = QUEUE_OPTION_DEFAULTS.keys

        attr_reader :exchange_defaults, :queue_defaults, :worker_defaults, :runner_defaults

        @exchange_defaults  = Sneakers::Configuration::EXCHANGE_OPTION_DEFAULTS
        @queue_defaults     = Sneakers::Configuration::QUEUE_OPTION_DEFAULTS

        @worker_defaults = WORKER_KEYS.reduce({}) do |dict, key|
          dict.update(key => Sneakers::Configuration::DEFAULTS[key])
        end

        @runner_defaults = RUNNER_KEYS.reduce({}) do |dict, key|
          dict.update(key => Sneakers::Configuration::DEFAULTS[key])
        end

      end
    end
  end
end
