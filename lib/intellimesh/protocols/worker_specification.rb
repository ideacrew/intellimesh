# frozen_string_literal: true

module Intellimesh
  module Protocols
    class WorkerSpecification
      attr_reader :protocol
      attr_reader :protocol_worker_specification

      def initialize(args = {})
        d_args = args.dup
        proto = d_args.delete(:protocol)
        case proto
        when :amqp, "amqp"
          @protocol = proto
          @protocol_worker_specification = ::Intellimesh::Protocols::Amqp::WorkerSpecification.new(
            d_args
          )
        else
          raise ::Intellimesh::Protocols::Errors::InvalidWorkerProtocolError, proto
        end
      end
    end
  end
end
