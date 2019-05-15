# frozen_string_literal: true

require 'active_support'

module Intellimesh
  module Adapters
    class Adapter

      attr_reader :broker

      attr_accessor :workers

      attr_accessor :producers

      def initialize(broker:, **options)
        @broker = broker
      end

      def connect(adapter_klass)
      end

      def configure_broker
        yield self if server?
      end


    end
  end
end
