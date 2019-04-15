# frozen_string_literal: true

require "active_support"
require "intellimesh/version"
require "intellimesh/config"
require "intellimesh/publishers"
require "intellimesh/subscribers"
require File.join(File.dirname(__FILE__), "intellimesh", "configuration")
require File.join(File.dirname(__FILE__), "intellimesh", "process_host")
require File.join(File.dirname(__FILE__), "intellimesh", "protocols")
require File.join(File.dirname(__FILE__), "intellimesh", "generators") if defined?(Rails)

# require "intellimesh/amqp/worker_specification"

module Intellimesh
  class Error < StandardError; end
end
