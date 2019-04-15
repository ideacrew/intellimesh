# frozen_string_literal: true

module Intellimesh
  module Subscribers
    module Errors

      class TimeoutError < Intellimesh::Errors::IntellimeshError
        def initialize(active_job, task)
          super(
            compose_message(
              "timeout_error", 
              {
                active_job: active_job,
                task: task,
              }
            )
          )
        end
      end

    end
  end
end
