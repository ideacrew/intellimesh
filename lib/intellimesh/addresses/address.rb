# frozen_string_literal: true

require 'uri'

module Intellimesh
  module Addresses
    module Address

      amqp_host     = "amqp://domain_name:port"
      amqp_send_to  = "amqp://exchange_name/routing_key"
      amqp_reply_to = "amqp://exchange_name/routing_key?queue_name=queue?"

# URI components
# * Scheme
# * Userinfo
# * Host
# * Port
# * Registry
# * Path
# * Opaque
# * Query
# * Fragment

    end
  end
end