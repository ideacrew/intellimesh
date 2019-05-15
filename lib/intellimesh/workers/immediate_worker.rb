module Intellimesh
  module Workers
    class ImmediateWorker < Worker

      def connection_config
        {
          heartbeat: 5,
          start_worker_delay: 0,
        }
      end

    end
  end
end
