module Intellimesh
  module Subscriptions
    class Subscription
      include Intellimesh::Loggable
      
      attr_reader :adapter, :destination, :consumer, :options

      def initialize(adapter, destination, consumer, options = {})
        @adapter = adapter
        @destination = destination
        @consumer = consumer
        @options = options
      end

      def unsubscribe
        raise 'must be implemented in subclass'
      end
    end
  end
end
