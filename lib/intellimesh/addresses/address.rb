# frozen_string_literal: true

require 'uri'

module Intellimesh
  module Addresses
    class Address

      URI_SCHEME        = 'uri'
      URI_COMPONENTS    = %w[ userinfo host port path query ].freeze
      QUERY_COMPONENTS  = %w[]

      attr_accessor :userinfo, :host, :port, :path, :query, :scheme
      # attr_writer :userinfo, :host, :port, :path, :query 
      # attr_reader :scheme

      def initialize(**options)
        @scheme = URI_SCHEME

        options.each_pair do |k, v|
          # rubocop:disable Style/RedundantSelf
          self.send("#{k}=", v)
          # rubocop:enable Style/RedundantSelf
        end

        self
      end

      def to_uri
        host_and_port = [host, port].compact.join(":")
        uri_str = scheme + "://" + [userinfo, ""].compact.join("@") + [host_and_port, path, query].compact.join("/")
        URI.join(uri_str)
      end

      def query
        QUERY_COMPONENTS.reduce("") do |query_str, component|
          query_str + "?#{component}=#{component}" if component.present?
        end
      end

    end
  end
end