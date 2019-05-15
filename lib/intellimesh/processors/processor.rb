# frozen_string_literal: true

require 'active_support/concern'

module Intellimesh
  module Processors
    module Processor
      extend ActiveSupport::Concern

      # Sneakers Worker service associated with this processor
      attr_reader :worker_name

      attr_reader :source_message_header

      attr_reader :source_message_meta

      attr_reader :source_message_body

      attr_reader :reply_to_component_name

      attr_reader :reply_to_exchange_name

      attr_reader :reply_to_routing_key


      module ClassMethods
      end

      def initialize(message)
        source_message = Intellimesh::Messages::Message.parse(message)
        @source_message_header    = source_message[:header]
        @source_message_meta      = source_message[:meta]
        @source_message_body      = source_message[:body]

        @reply_to_component_name  = @message_header[:reply_to_component_name]
        @reply_to_exchange_name   = @message_header[:reply_to_exchange_name]
        @reply_to_routing_key     = [
                                        @source_message_header[:application_name],
                                        @source_message_header[:job_id]
                                      ].join('.')

      end

    end
  end
end
