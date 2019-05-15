# frozen_string_literal: true

# AWS Simple Queue Service
module Intellimesh
  module Adapters
    module Sqs
      class SqsAdapter < Intellimesh::Adapters::Adapter

        def data_key=(data_key)
        end

        def encryption_context=(**opts)
        end

        def data_key_reuse_period=(period = 5.minutes)
        end

      end
    end
  end
end
