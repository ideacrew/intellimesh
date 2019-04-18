# frozen_string_literal: true

require "rails/generators"

module Intellimesh
  module Generators
    class MongoidInitializerGenerator < Rails::Generators::Base
      desc "Generate the Mongoid initialization file that enables GlobalID."
      def create_mongoid_initializer_file
        create_file("config/initializers/mongoid.rb", {:skip => true}) do
<<RUBYCODE
if defined?(Mongoid)
  # GlobalID is used by ActiveJob (among other things)
  # https://github.com/rails/globalid

  Mongoid::Document.send(:include, GlobalID::Identification)

  if Mongoid::VERSION.split('.').first.to_i < 7
    Mongoid::Relations::Proxy.send(:include, GlobalID::Identification)
  else
    Mongoid::Association::Proxy.send(:include, GlobalID::Identification)
  end
end
RUBYCODE
        end
      end
    end
  end
end
