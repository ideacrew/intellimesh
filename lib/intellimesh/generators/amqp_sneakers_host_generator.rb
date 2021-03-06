# frozen_string_literal: true

require "rails/generators"

module Intellimesh
  module Generators
    # Provides the generator for the script you will need to run alongside your
    # Rails process to host the ActiveJob processes.
    class AmqpSneakersHostGenerator < Rails::Generators::Base
      desc "Generate the worker host runner script for sneakers active jobs."
      def create_sneakers_active_job_host_file
        create_file("script/sneakers_active_job_host.rb", {:skip => true}) do
<<RUBYCODE
require 'sneakers'
require 'sneakers/runner'

# Configure the basic program variables
Intellimesh::Configuration.site_name = ENV['IC_SITE_NAME']
Intellimesh::Configuration.environment_name = ENV['IC_ENVIRONMENT_NAME']

# Supply configuration provider, default is Diplomat
diplomat_configuration_provider = Intellimesh::Configuration::DiplomatProvider.new(
  ENV['IC_DIPLOMAT_URL'],
  ENV['IC_CONSUL_TOKEN']
)

# Configure Sneakers
sneakers_configuration = Intellimesh::ProcessHost::Configuration::SneakersConfiguration.new(
  File.join(Rails.root, "log", "sneakers_sneakers_active_job_host.pid")
)

Intellimesh::ProcessHost::SneakersActiveJobHost.run(diplomat_configuration_provider, sneakers_configuration)
RUBYCODE
        end
      end
    end
  end
end
