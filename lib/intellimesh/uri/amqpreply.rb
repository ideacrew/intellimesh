# frozen_string_literal: true

module URI
  # In order to reply to any given AMQP message, you need 3 distinct pieces
  # of information:
  #   - Exchange Name
  #   - Exchange Type
  #   - Routing Key
  # Optionally, a correlation ID could be provided as part of the URI, but
  # this is usually present in the message envelope.
  #
  # It is possible we will unify the classes for AMQP URI - 
  # but at the moment I am exploring the fact that different objects and
  # items in AMQP suggest wildly different URI schemes.
  class AMQPReply < Generic
    def exchange_name
      host
    end

    def exchange_type
      userinfo
    end

    def routing_key
      path.gsub("/", "")
    end
  end
  @@schemes['AMQPREPLY'] = AMQPReply
end