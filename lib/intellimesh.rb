# frozen_string_literal: true

require "active_support"
require "intellimesh/version"
# Not quite ready for prime time yet - still has a large amount of noise
# require "intellimesh/config"
require "intellimesh/publishers"
require "intellimesh/subscribers"
require File.join(File.dirname(__FILE__), "intellimesh", "configuration")

# require "intellimesh/amqp/worker_specification"

module Intellimesh
  class Error < StandardError; end
end
