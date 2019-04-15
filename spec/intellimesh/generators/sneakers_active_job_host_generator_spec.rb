# frozen_string_literal: true

require "spec_helper"

RSpec.describe Intellimesh::Generators::SneakersActiveJobHostGenerator do
  it "provides the generator task" do
    the_generator_ns = Rails::Generators.sorted_groups.detect { |ns_list| ns_list.first == "intellimesh" }
    expect(the_generator_ns.last).to include("intellimesh:sneakers_active_job_host")
  end
end
