# frozen_string_literal: true

require 'active_support/concern'

module Publishers
  class Publisher
# Sneakers::Publisher
#   #initialize(opts)
#   #publish(msg, options)

    def initialize(from_address:, to_address:, reply_to_address:, message:, options:); end
  end
end
