# frozen_string_literal: true

require "sneakers"

module Intellimesh
  module Protocols
    module Amqp
      # Extentions to augment sneakers functionality.
      # == Why do we need this and what does it do?
      # Out of the box, sneakers workers don't have access to the underlying
      # connection object they use.  This means that workers are able to
      # ack, nack, error, and reject in response to a message - but they are
      # *not* capable of sending their own.  This gives sneakers workers a way
      # to access the underlying connection - and thus send responses or
      # broadcast events of their own.
      module SneakersExtensions
        # Methods to allow a Sneakers Queue object access to the underlying
        # AMQP connection.  This also exposes it so a corresponding worker
        # is able to reach the object.
        module QueueExtensions
          # @return [Bunny::Session] the underlying session or connection
          def connection
            @bunny
          end
        end

        # Methods to allow a Worker access to the underlying
        # AMQP connection.
        #
        # These are pulled into Sneakers::Worker, and are available as
        # instance methods to any users of that module.
        module WorkerExtensions
          # @return [Bunny::Session] the underlying session or connection
          def connection
            queue.connection
          end

          # Open a channel on our existing connection to perform messaging.
          #
          # Will yield the new channel, confirm any messages sent, and
          # then close the channel.
          # @yield [Bunny::Channel]
          def with_confirmed_channel
            chan = connection.create_channel
            begin
              chan.confirm_select
              yield chan
              chan.wait_for_confirms
            ensure
              chan.close
            end
          end
        end
      end
    end
  end
end

Sneakers::Queue.class_eval do
  include Intellimesh::Protocols::Amqp::SneakersExtensions::QueueExtensions
end

Sneakers::Worker.module_eval do
  include Intellimesh::Protocols::Amqp::SneakersExtensions::WorkerExtensions
end
