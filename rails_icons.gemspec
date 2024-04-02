# frozen_string_literal: true

require_relative "lib/rails_icons/version"

Gem::Specification.new do |spec|
  spec.name = "rails_icons"
  spec.version = RailsIcons::VERSION
  spec.authors = ["Rails Designer Developers"]
  spec.email = ["devs@railsdesigner.com"]

  spec.summary = "Add icons from multiple icons in your Rails app"
  spec.description = "Add SVG icons from multiple libraries, or your own custom icon set with this one gem."
  spec.homepage = "https://railsdesigner.com/rails-icons/"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Rails-Designer/rails_icons/"

  spec.files = Dir["{bin,app,config,db,lib,public}/**/*", "Rakefile", "README.md", "rails_icons.gemspec", "Gemfile", "Gemfile.lock"]

  spec.required_ruby_version = ">= 3.0.0"
  spec.add_dependency "rails", "> 6.1"
  spec.add_runtime_dependency "nokogiri", "~> 1.16", ">= 1.16.4"
end
