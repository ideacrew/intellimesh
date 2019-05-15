# frozen_string_literal: true

module Intellimesh
  module Exchanges
    module Exchange
      extend ActiveSupport::Concern

      included do
        class_attribute :_exchange, instance_accessor: false, instance_predicate: false
        class_attribute :_exchange_name, instance_accessor: false, instance_predicate: false
      end

      module ClassMethods
        DEFAULT_EXCHANGE_NAME = :default

        def exchange
          _exchange
        end

        def exchange_name=(name_or_exchange = DEFAULT_EXCHANGE_NAME)
          case name_or_exchange
          when Symbol, String
            exchange = registered_exchange_lookup(name_or_exchange).new
            assign_exchange(name_or_exchange.to_s, exchange)
          else
            if is_exchange?(name_or_exchange)
              name = "#{name_or_exchange.class.name.demodulize.underscore}"
              assign_exchange(name, name_or_exchange)
            else
              raise ArgumentError
            end
          end

        end
      end

      private

      def assign_exchange(exchange_name, exchange)
        self._exchange_name = exchange_name
        self._exchange = exchange
      end

      EXCHANGE_METHODS  = [:enqueue].freeze

      def is_exchange?(object)
        EXCHANGE_METHODS.all? { |method| object.respond_to?(method) }
      end
    end
  end
end

