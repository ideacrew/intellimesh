# frozen_string_literal: true

module Intellimesh
  module Messages
    class Message
        # header (envelope)
        # body
        # metadata

      HEADER_PROPERTIES = %w[from_address to_address reply_to_address submitted_at auth metadata mime_type]
      BODY_PROPERTIES   = %w[body attachments]

      def initialize(**options)
        parse_options(options) unless options.empty?

        # Target must be a URI
        @to = to_uri(options[:to])
      end

      def parse_options(options)
        # @header =
      end

      def parse; end

      def header
        @header
      end

      def header=(hash); end

      def from_address=(uri); end

      def to_address=(uri); end

      def reply_to_address=(uri); end

      def metadata=(hash); end

      def body=(message)
        { body: message }
      end

      def attachments; end

      def log_inspect()
        <<-LOGSTRING
        From: #{from.to_s}
          To: #{to.to_s}
          #{log_body}
          LOGSTRING
      end

      private

      def log_body
        return("------- NIL BODY VALUE ------") if body.nil?
        if body.respond_to?(:size)
          if body.size > 1024
            "------- Large body > 1024 bytes -------"
          else
            body.to_s
          end
        end
      end
    end
  end
end
