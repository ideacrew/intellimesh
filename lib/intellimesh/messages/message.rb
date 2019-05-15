# frozen_string_literal: true

require 'active_support/concern'
require 'securerandom'

module Intellimesh
  module Messages
    module Message
      extend ActiveSupport::Concern
      # include Logging

      HEADER_META_DEFAULTS 		= {}
      HEADER_CONTEXT_DEFAULTS = {
        priority:         :now,       # => (Symbol) :immediate, :hourly, :daily
        enqueued_at:     	nil,        # => (UTC Time) timestamp when this message was enqueued
        expires:          0,          # => (Integer) duration in seconds following the enqueued_at timestamp that message is dequeued. Zero means that message doesn't expire
        reply_to:         nil,        # => (URI) the exchange/queue the sender expects replies to
        routing_slip: 		{},					# => Workflow multi-step process and tracking
      }

      HEADER_DEFAULTS =
      {
        id:               nil,        # => (UUID) unique identifier for this message
        from:             nil,        # => (URI) application ID of the message sender
        to:               nil,        # => (URI) destination exchange or exchange/queue address
        subject:          nil,
        submitted_at:     nil,        # => (UTC Time) timestamp when this message was enqueued
        type:             :object,    # => (Symbol) :text | :object (json) | :bytes
        errors:           {},    			# => (Hash)
        context:     			{},         # => (Hash) execution state, process flow and routing
        meta:     				{},         # => (Hash) application-defined properties
      }

      HEADER_KEYS             = HEADER_DEFAULTS.keys
      HEADER_CONTEXT_KEYS			= HEADER_CONTEXT_DEFAULTS.keys
      MESSAGE_TYPES           = [:text, :object, :bytes]
      MESSAGE_PRIORITY_TYPES  = [:now, :hourly, :daily]

      class_methods do
        # parse a message instance
        def read_message(message)
        end

        def to_json
        end
      end

      included do
        attr_reader :message_header, :message_context, :message_meta, :message_body

        # Create or update properties for paased params in the appropriate message section
        def message(**options)
          reset_message! unless @message.present?

          options.each_pair do |key, value|
            key == :body ? @message_body = value : update_message_header({key => value})
          end

          @message
        end

        def full_message
          reset_message! unless @message.present?
          @message = { header: message_header, body: message_body }
        end

        def message_ack(options = {})
          if context.supports_client_acks?
            context.ack_message(self, options)
          else
            logger.debug('this adapter does not support client acks')
          end
        end

        def message_nack(options = {})
          if context.supports_client_acks?
            context.nack_message(self, options)
          else
            logger.debug('this adapter does not support client acks')
          end
        end

        # Set or update message header properties.   If the property isn't one of
        # the recognized keys, it goes into the meta section
        def update_message_header(**new_properties)
          reset_message! unless @message.present?

          new_properties.each_pair do |key, value|
            case key
            when :id then raise ArgumentError, "id attribute is readonly"
            when :body then next
            when :context, :meta
            	value.each_pair { |k,v| update_message_header({k => v}) }
            else
              if HEADER_KEYS.include?(key)
                @message_header.update({key => value})
              elsif HEADER_CONTEXT_KEYS.include?(key)
                self.send(:update_message_context, {key => value})
              else
                self.send(:update_message_meta, {key => value})
              end
            end

            @message_header
          end
        end

        def reset_message!
          self.send(:initialize_message)
        end

        private

        def update_message_context(**new_properties)

          @message_context = hash_merge([@message_context, new_properties])
          @message_header[:context] = @message_context

          @message_context
        end

        def update_message_meta(**new_properties)

          @message_meta == {} ? @message_meta = new_properties : @message_meta = hash_merge([@message_meta, new_properties])
          @message_header[:meta] = @message_meta

          @message_meta
        end

        def initialize_message
          @message_context        	= HEADER_CONTEXT_DEFAULTS
          @message_meta           	= HEADER_META_DEFAULTS
          @message_header         	= HEADER_DEFAULTS
          @message_header[:id]    	= unique_id
          @message_header[:context]	= @message_context
          @message_header[:meta]		= @message_meta
          @message_body           	= {}

          @message = { header: @message_header, body: @message_body }
        end

        def message_priority(priority)
          raise ArgumentError, "undefined priority type :#{priority}, use: #{MESSAGE_PRIORITY_TYPES.to_s}" unless MESSAGE_PRIORITY_TYPES.include? priority
          @message_header[:priority] = priority
        end

        def unique_id
          SecureRandom.uuid
        end

        def log_inspect()
          <<-LOGSTRING
          From: #{from.to_s}
            To: #{to.to_s}
            #{log_body}
            LOGSTRING
        end

        def hash_merge(hashes = [])
          hashes.inject(:merge)
        end
      end
    end
  end
end
