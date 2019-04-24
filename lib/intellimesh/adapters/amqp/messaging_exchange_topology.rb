# frozen_string_literal: true

require 'bunny'

module Intellimesh
  module Protocols
    module Amqp
      class MessagingExchangeTopology
        def self.ensure_topology_exists(connection_string)
          topology = new(connection_string)
          topology.setup
          topology.close
        end

        def initialize(connection_string)
          @connection = Bunny.new(connection_string, :heartbeat => 15)
          @connection.start
          @channel = @connection.create_channel
        end

        def setup
          event_fanout = @channel.fanout(event_fanout_exchange_name, { :durable => true })
          event_topic = @channel.topic(event_topic_exchange_name, { :durable => true })
          event_direct = @channel.direct(event_direct_exchange_name, { :durable => true })

          event_topic.bind(event_fanout)
          event_direct.bind(event_fanout)

          request_fanout = @channel.fanout(request_fanout_exchange_name, { :durable => true })
          request_topic = @channel.topic(request_topic_exchange_name, { :durable => true })
          request_direct = @channel.direct(request_direct_exchange_name, { :durable => true })

          request_topic.bind(request_fanout)
          request_direct.bind(request_fanout)
        end

        def close
          @channel.close
          @connection.close
        end

        protected

        def common_exchange_prefix
          hbx_id = ::Intellimesh::Configuration.tenant_name
          env_name = ::Intellimesh::Configuration.environment_name
          "#{hbx_id}.#{env_name}.e."
        end

        def event_fanout_exchange_name
          common_exchange_prefix + "fanout.events"
        end

        def event_topic_exchange_name
          common_exchange_prefix + "topic.events"
        end

        def event_direct_exchange_name
          common_exchange_prefix + "direct.events"
        end

        def request_fanout_exchange_name
          common_exchange_prefix + "fanout.requests"
        end

        def request_direct_exchange_name
          common_exchange_prefix + "direct.requests"
        end

        def request_topic_exchange_name
          common_exchange_prefix + "topic.requests"
        end
      end
    end
  end
end
