# frozen_string_literal: true

module Intellimesh
  module Errors
    class IntellimeshError < StandardError
      def compose_message(message, active_job, task); end
    end

    class Error < StandardError; end
    class BrokerNotConfigured < Error; end
    class BrokerAlreadyConfigured < Error; end
    class TransactionError < Error; end
    class TransactionRollbackOnly < TransactionError; end
    class NoSuchDestinationError < Error; end
    class NoSuchConsumerError < Error; end

    class WrappedError < Error
      # include Nesty::NestedError
    end
    class QueueNotFound < WrappedError; end
    class ConnectionError < WrappedError; end

    module DontRequeue; end
    class DontRequeueError < Error
      # include DontRequeue
    end

    class WrappedDontRequeueError < WrappedError
      # include DontRequeue
    end
  end
end
