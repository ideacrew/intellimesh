# frozen_string_literal: true

module Intellimesh
  module ProcessHost
    # Spawns and restarts sneakers workers using forked processes and shared memory,
    # acting as the host service for a set of configured sneakers workers.
    #
    # This host is used to manage the lifecycle of workers who participate in pub/sub
    # based sneakers worker behaviour.
    class SneakersWorkerHost
    end
  end
end
