# frozen_string_literal: true

module Intellimesh
  module Addresses
    class AmqpAddress < Address
      attr_writer :exchange_name, :routing_key, :queue_name

      # amqp_host     = "amqp://domain_name:port"
      # amqp_send_to  = "amqp://exchange_name/queue_name?routing_key=routing_key"
      # amqp_reply_to = "amqp://exchange_name/queue_name?routing_key=routing_key"

      URI_SCHEME        = 'amqp'
      QUERY_COMPONENTS  = %w[ routing_key ].freeze

      def initialize(**options)
        super
        @exchange_name  ||= options[:exchange_name]
        @queue_name     ||= options[:queue_name]
        @routing_key    ||= options[:routing_key]
      end

      def address
        URI::join(scheme, host, path, query)
      end

      def host
        @exchange_name if defined
      end

      def path
        @queue_name
      end

      def exchange_name=(exchange_name)
        @exchange_name = exchange_name
      end

      def queue_name=(queue_name)
        @queue_name = "queue_name = #{queue_name}"
      end

      def routing_key=(routing_key)
        @routing_key = "routing_key=#{routing_key}"
      end
    end
  end
end
