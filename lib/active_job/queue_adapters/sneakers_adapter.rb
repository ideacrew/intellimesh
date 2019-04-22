module ActiveJob
  module QueueAdapters
    class SneakersAdapter

      def enqueue(job)
      end

      class JobWrapper
        include Sneakers::Worker
        from_queue "default"

        def work(msg)
        end
      end
    end
  end
end