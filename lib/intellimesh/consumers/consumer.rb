module Intellimesh
  module Consumers
    class Consumer

      NUMBER_OF_MESSAGES_TO_PREFETCH = 1

      def initialize(queue_name:, worker:, connection:)
        @queue_name = queue_name
        @worker     = worker
        @connection = connection
        @statsd_client = statsd_client
      end

      def run
        @connection.start

        queue.subscribe(block: true, manual_ack: true) do |delivery_info, headers, payload|
          begin
            message = Intellimesh::Messages::Message.new(payload, headers, delivery_info)
            @statsd_client.increment("#{@queue_name}.started")
            message_consumer.process(message)
            @statsd_client.increment("#{@queue_name}.#{message.status}")

          rescue Exception => e
            @statsd_client.increment("#{@queue_name}.uncaught_exception")
            GovukError.notify(e) if defined?(GovukError)
            @logger.error "Uncaught exception in processor: \n\n #{e.class}: #{e.message}\n\n#{e.backtrace.join("\n")}"
            exit(1) # Requeue failed message
          end
        end


        private

        def message_consumer
          @message_consumer ||= Intellimesh::MessageConsumer.new(
            processors: [
              HeartbeatProcessor.new,
              JSONProcessor.new,
              @processor,
            ]
          )
        end

        def queue
          @queue ||= begin
            channel.prefetch(self.class::NUMBER_OF_MESSAGES_TO_PREFETCH)
            channel.queue(@queue_name, no_declare: true)
          end
        end

        def channel
          @channel ||= @connection.create_channel
        end


      end
    end
  end
end
