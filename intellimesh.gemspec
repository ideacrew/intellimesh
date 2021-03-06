# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "intellimesh/version"

Gem::Specification.new do |spec|
  spec.name          = "intellimesh"
  spec.version       = Intellimesh::VERSION
  spec.authors       = ["Dan Thomas"]
  spec.email         = ["dan@ideacrew.com"]

  spec.summary       = "IdeaCrew's smart integration"
  spec.description   = "IdeaCrew's smart integration"
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "IdeaCrew's smart integration."
  #   spec.metadata["changelog_uri"] = "IdeaCrew's smart integration."
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.test_files = Dir["spec/**/*"]

  # We want this to take full advantage of upcoming rails technologies.
  # However, we currently have a number of applications which are
  # unable to upgrade past this point.
  # Our first order of business will be to boost this requirement
  # to the Rails 5 series as soon as we can.
  # spec.add_dependency "rails", "~> 6.0.0.beta3"
  spec.add_dependency 'activejob',                '>= 5.0'
  spec.add_dependency 'activesupport',            '>= 5.0'
  spec.add_dependency 'active_model_serializers', '>= 0.10.0'
  spec.add_dependency 'sneakers',                 '>= 2.11'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'pry-byebug'
end
