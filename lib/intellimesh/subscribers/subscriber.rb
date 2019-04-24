# frozen_string_literal: true

module Intellimesh
  module Subscribers
    class Subscriber
# Sneakers::Queue
#   initialize(name, opts)
#   #subscribe(worker)
#   #unsubscribe

      def initialize(exchange:, queue:, options:)
        # options
        # :exchange :routing_key :heartbeat_interval :prefetch :durable :ack :handler
      end
    end
  end
end
