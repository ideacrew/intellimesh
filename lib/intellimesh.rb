# frozen_string_literal: true

require "active_support"

require "active_job/queue_adapters/sneakers_adapter"
require "intellimesh/addresses"
require "intellimesh/version"
require "intellimesh/clients"
require "intellimesh/loggable"
require "intellimesh/errors/intellimesh_error"
require "intellimesh/publishers"
require "intellimesh/subscribers"
require "intellimesh/uri"
require File.join(File.dirname(__FILE__), "intellimesh", "either")
require File.join(File.dirname(__FILE__), "intellimesh", "configuration")
require File.join(File.dirname(__FILE__), "intellimesh", "generators") if defined?(Rails)

# require "intellimesh/amqp/worker_specification"

module Intellimesh
  extend Loggable

  # class Error < StandardError; end
end
