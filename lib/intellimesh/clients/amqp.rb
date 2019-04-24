# frozen_string_literal: true

module Intellimesh
  module Clients
    module Amqp

      # included do
      #   include Sneakers::Worker
      #   attr_writer :resource_kind

      #   Intellimesh::Clients::Amqp.class_name ||= name.
      # end

      ## Class Methods
      module ClassMethods
        def my_class_method; end
      end

      def self.included(base)
        base.extend ClassMethods
      end

        def publisher; end

        # Use the ActiveJob queue attribute to determine
        def worker_service; end

        # Instance Methods

        def subscriber=(amqp_subscriber); end

        def message; end

        private

        # Unique routing key address for response callback
        def generate_reply_to; end

    end
  end
end
