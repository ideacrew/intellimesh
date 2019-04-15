# frozen_string_literal: true

module Intellimesh
  module Errors
    class IntellimeshError < StandardError
      def compose_message(active_job, task); end
    end
  end
end
