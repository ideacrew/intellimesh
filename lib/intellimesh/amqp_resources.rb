# frozen_string_literal: true
module Intellimesh
  module AmqpResources

    KIND_MAPPINGS = {
      event_publisher:              EventPublisher,
      service_request_publisher:    ServiceRequestPublisher,
      tracked_event_publisher:      TrackedEventPublisher,
      event_subsriber:              EventSubscriber,
      service_request_subscriber:   ServiceRequestSubscriber,
      tracked_event_subscriber:     TrackedEventSubscriber,
    }


    module ClassMethods

      # Use Worker YAML Config File
      # Specify an ENV WORKER_GROUP_CONFIG as a path to YAML file (or by convention ./config/sneaker_worker_groups.yml)
      # bundle exec ruby -e "require 'sneakers/spawner';Sneakers::Spawner.spawn"

      # # Worker Group File Structure
      # real_time_publish_worker:
      #   classes: HourlyWorker
      #   workers: 8
      # hourly_publish_worker:
      #   classes: HourlyWorker
      #   workers: 8
      # daily_publish_worker:
      #   classes: DailyWorker
      #   workers: 10

      # amqp_publisher :member_address_change, 
      #                 kind: ServiceRequestPublisher, 
      #                 exchange: :member_tracked_events,
      #                 # from_queue: :downloads,
      #                 reply_to_queu: :member_address_change_fa43670, # add to message
      #                 prefetch: 10,
      #                 threads: 10,
      #                 env: ENV['RACK_ENV'],
      #                 timeout_job_after: 5,
      #                 durable: true,
      #                 ack: true,
      #                 hertbeat: 10,
      #                 hooks: {},
      #                 start_worker_dealy: 0,
      #                 message: message,


      # # Local (per worker)
      # include Sneakers::Worker
      # amqp_subscriber :member_address_change, 
      #                 kind: ServiceRequestSubscriber, 
      #                 exchange: :member_tracked_events,
      #                 from_queue: :member_address_change_fa43670,
      #                 env: ENV['RACK_ENV'],
      #                 prefetch: 1,
      #                 threads: 1,
      #                 timeout_job_after: 5,
      #                 durable: true,
      #                 ack: true,
      #                 hertbeat: 10,
      #                 hooks: {},
      #                 start_worker_dealy: 0,
      #                 message: message


      def amqp_resource(name, options = {})
        named = name.to_s
        validate(self, name, options)
        add_amqp_resource(named, options)
      end
    end

  end
end
