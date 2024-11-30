# frozen_string_literal: true

require_relative "lib/rails_icons/version"

Gem::Specification.new do |spec|
  spec.name = "rails_icons"
  spec.version = RailsIcons::VERSION
  spec.authors = ["Rails Designer Developers"]
  spec.email = ["devs@railsdesigner.com"]

  spec.summary = "Add any icon library to a Rails app"
  spec.description = "Add any icon library to a Rails app, from Heroicons, to Lucide to Tabler (and others). Rails Icons is library-agnostic, so you can add any library while using the same interface."
  spec.homepage = "https://railsdesigner.com/rails-icons/"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Rails-Designer/rails_icons/"

  spec.files = Dir["{bin,app,config,db,lib,public}/**/*", "Rakefile", "README.md", "rails_icons.gemspec", "Gemfile", "Gemfile.lock"]

  spec.required_ruby_version = ">= 3.1.0"
  spec.add_dependency "rails", "> 6.1"
  spec.add_runtime_dependency "nokogiri", "~> 1.16", ">= 1.16.4"
end
