require "active_support"

require "intellimesh/version"
# require "intellimesh/config"
require "intellimesh/publishers"
require "intellimesh/subscribers"
require "intellimesh/loggable"


# require "intellimesh/amqp/worker_specification"

module Intellimesh
  extend Loggable

  class Error < StandardError; end
  # Your code goes here...
end
