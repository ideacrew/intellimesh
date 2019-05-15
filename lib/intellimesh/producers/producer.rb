# frozen_string_literal: true

require 'intellimesh/exchanges/callbacks'
require 'active_support/concern'
require 'active_support/inflector'
require 'securerandom'

module Intellimesh
  module Producers
    module Producer
      extend ActiveSupport::Concern

      # RabbitMQ Exchange where messages are posted
      attr_writer :job_id

      # RabbitMQ Exchange where messages are posted
      attr_writer :exchange_name

      # Exchange name where this application listens for posted responses
      attr_writer :reply_to_exchange_name

      # Timestamp when Job was enqueued
      attr_accessor :enqueued_at

      # I18n.locale to be used during the job.
      attr_accessor :locale

      # Job arguments
      attr_accessor :arguments

      module ClassMethods
        def set(options = {})
          ConfiguredJob.new(self, options)
        end

        def perform_now(*args)
          job_or_instantiate(*args).perform_now
        end

        def execute(job_data)
          Callbacks.run_callbacks(:execute) do
            job = deserialize(job_data)
            job.perform_now
          end
        end
      end

      def initialize(*arguments)
        @job_id                   = SecureRandom.uuid
        @exchange_name            = exchange_name_for_job_class
        @reply_to_exchange_name   = @job_id

        @arguments                = arguments
        @enqueued_at              = Time.now.utc.iso8601
        @locale                   = I18n.locale.to_s
      end

      def perform_now
        run_callbacks :perform do
          perform(*arguments)
        end
      rescue => exception
        rescue_with_handler(exception) || raise
      end

      def perform(*)
        fail NotImplementedError
      end


      private

      def exchange_name_for_job_class
        self.name.demodulize.delete_suffix('Job').underscore.dasherize
      end

      def reply_exchange_name_for()
      end

    end
  end
end
