# frozen_string_literal: true

require "rails/generators"

module Intellimesh
  module Generators
    class SneakersWorkerGenerator < Rails::Generators::NamedBase
      desc "Generate a sneakers worker."
      def create_worker_file
        create_file("config/initializers/register_sneakers_workers.rb", {:skip =>  true}) do
          ""
        end
        append_to_file("config/initializers/register_sneakers_workers.rb") do
          "Intellimesh::Protocols.register_amqp_worker(\"::Subscribers::#{name}\")\n"
        end
        create_file "app/models/subscribers/#{name.underscore}.rb", <<RUBYCODE
module Subscribers
  class #{name}

    def self.worker_specification
      ::Intellimesh::Protocols::WorkerSpecification.new(
        :protocol => :amqp,
        :queue_name => "#{name.underscore}",
        :kind => :direct,
        :routing_key => "#{name.underscore}"
      )
    end

    def work_with_params(body, delivery_info, properties)
    end
  end
end
RUBYCODE

        invoke "intellimesh:sneakers_process_host"
      end
    end
  end
end