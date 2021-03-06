module Intellimesh
  module Addresses
    class AmqpAddress < Address

      # amqp_send_to  = "amqp://exchange_name/queue_name?routing_key=value?exchange_type=value"
      # amqp_reply_to = "amqp://exchange_name/queue_name?routing_key=value"

      URI_SCHEME        = 'amqp'
      QUERY_COMPONENTS  = %w[routing_key exchange_type].freeze

      attr_accessor :exchange_name, :exchange_type, :routing_key, :queue_name

      def initialize(**options)
        super(options)
        @scheme = URI_SCHEME
        @query_components = QUERY_COMPONENTS

        to_uri
      end

      def host
        exchange_name if defined? exchange_name
      end

      def path
        queue_name if defined? queue_name
      end

      def routing_key=(routing_key)
        @routing_key = routing_key
      end

      def exchange_type=(exchange_type)
        @exchange_type = exchange_type
      end

    end
  end
end