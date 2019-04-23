module ActiveJob
  module QueueAdapters
    class SneakersAdapter

      def enqueue(job)
      end

      class JobWrapper
        from_queue "default"

        def work(msg)
        end

        def work_daily(msg)
        end

        def work_hourly(msg)
        end

      end
    end
  end
end