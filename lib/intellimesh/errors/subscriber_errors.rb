module Intellimesh
  module Errors
    module SubscriberErrors

      class TimeoutError < IntellimeshError
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
