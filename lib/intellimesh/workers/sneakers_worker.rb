# frozen_string_literal: true
module Worker
  class SneakersWorker < Worker



    Sneakers.configure {
      retry_exchange: 'activejob-retry',
      retry_error_exchange: 'activejob-error',
      retry_requeue_exchange: 'activejob-retry-requeue'
    }

  end
end