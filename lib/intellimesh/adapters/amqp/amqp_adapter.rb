# frozen_string_literal: true

# RabbitMQ Adapter
module Intellimesh
  module Adapters
    module Amqp
      class AmpqAdapter < Intellimesh::Adapters::Adapter

# Sneakers
# $ sneakers run TitleWorker,FooWorker
# $ sneakers stop
# $ sneakers recycle
# $ sneakers reload
# $ sneakers init
# CONFIG = Configuration.new

# Sneakers::Queue
#   initialize(name, opts)
#   #subscribe(worker)
#   #unsubscribe

# Sneakers::Publisher
#   #initialize(opts)
#   #publish(msg, options)

# Module Sneakers::Worker
# Class methods
#   #included(base)
# Instance Methods
#   #initialize(queue, pool, opts)
#   #ack!
#   #do_work(delivery_info, metadata, msg, handler)
#   #log_msg(msg)
#   #publish(msg, opts)
#   #reject!
#   #requeue!
#   #run
#   #stop
#   #worker_error(msg, exception)
#   #worker_trace(msg)

# Module Sneakers::Worker::ClassMethods
# In more advanced scenarios you would be able to mix in components of a worker into your own worker class
# Instance methods
#   #enqueue(msg)
#   #from_queue(q, opts = {})

# Module Sneakers::WorkerGroup
#   #after_fork
#   #before_fork
#   #initilize
#   #run
#   #stop

# Sneakers::HAndlers::Maxretry
# Sneakers::HAndlers::Oneshot


      end
    end
  end
end
