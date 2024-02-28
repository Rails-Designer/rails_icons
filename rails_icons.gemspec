# frozen_string_literal: true

require_relative "lib/rails_icons/version"

Gem::Specification.new do |spec|
  spec.name = "rails_icons"
  spec.version = RailsIcons::VERSION
  spec.authors = ["Rails Designer Developers"]
  spec.email = ["developers@railsdesigner.com"]

  spec.summary = "Add icons from multiple icons in your Rails app"
  spec.description = "Add SVG icons from multiple libraries, or your own custom icon set with this one gem."
  spec.homepage = "https://github.com/Rails-Designer/rails_icons/"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Rails-Designer/rails_icons/"
  spec.metadata["changelog_uri"] = "https://github.com/Rails-Designer/rails_icons/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
