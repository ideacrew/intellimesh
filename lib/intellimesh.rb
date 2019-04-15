# frozen_string_literal: true

require "active_support"

require "intellimesh/version"
require "intellimesh/loggable"
require "intellimesh/errors/intellimesh_error"

# Not quite ready for prime time yet - still has a large amount of noise
# require "intellimesh/config"
require "intellimesh/publishers"
require "intellimesh/subscribers"
require File.join(File.dirname(__FILE__), "intellimesh", "configuration")
require File.join(File.dirname(__FILE__), "intellimesh", "process_host")
require File.join(File.dirname(__FILE__), "intellimesh", "generators") if defined?(Rails)

# require "intellimesh/amqp/worker_specification"

module Intellimesh
  extend Loggable

  # class Error < StandardError; end
end
