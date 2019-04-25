# frozen_string_literal: true

require 'uri'

module Intellimesh
  module Addresses
    class Address

      URI_SCHEME        = 'uri'
      URI_COMPONENTS    = %w[userinfo host port path query].freeze
      QUERY_COMPONENTS  = %w[]

      attr_accessor :userinfo, :host, :port, :path, :query, :scheme

      def initialize(**options)
        @scheme = URI_SCHEME
        @query_components = QUERY_COMPONENTS

        options.each_pair do |k, v|
          # rubocop:disable Style/RedundantSelf
          self.send("#{k}=", v)
          # rubocop:enable Style/RedundantSelf
        end

        self
      end

      def to_uri
        host_and_port_str = [host, port].compact.join(":")
        query_str = query
        uri_str = scheme + "://" + 
                  [userinfo, ""].compact.join("@") + 
                  [host_and_port_str, path].compact.join("/")
        uri_str = uri_str + query_str if query_str.present?

        URI.join(uri_str)
      end

      def query
        # binding.pry
        @query_components.reduce("") do |query_str, component|
          query_str + "?#{component}=#{instance_eval(component)}" if instance_eval(component).present?
        end
      end

    end
  end
end