# frozen_string_literal: true

require "rails_icons/base_generator"

module RailsIcons
  class InstallGenerator < RailsIcons::BaseGenerator
    source_root File.expand_path("templates", __dir__)

    desc "Install Rails Icons with the chosen libraries. This creates the configuration initializer and will sync the icons."

    class_option :library, type: :string, desc: "Choose libraries (#{RailsIcons.libraries.keys.join("/")})"
    class_option :libraries, type: :array, default: [], desc: "Choose libraries (#{RailsIcons.libraries.keys.join("/")})"
    class_option :destination, type: :string, default: RailsIcons.configuration.icons_path, desc: "Specify destination folder for icons"
    class_option :skip_sync, type: :boolean, default: false

    def initializer_generator
      generate("rails_icons:initializer", *attributes)
    end

    def sync_generator
      return if options[:skip_sync] || libraries.blank?

      generate("rails_icons:sync", *attributes)
    end

    def add_route
      unless file_contains?("config/routes.rb", "mount RailsIcons::Engine")
        inject_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
          "  mount RailsIcons::Engine, at: '/rails_icons'\n"
        end
      end
    end

    private

    def attributes
      ["--libraries=#{libraries.map(&:downcase).join(" ")}", "--destination=#{options[:destination]}"].join(" ")
    end

    def libraries
      [*options.libraries, options.library].compact_blank
    end

    def validatable? = true
  end
end
