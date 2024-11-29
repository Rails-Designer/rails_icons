# frozen_string_literal: true

module RailsIcons
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    class_option :libraries, type: :array, default: ["heroicons"], desc: "Choose libraries (#{RailsIcons::Libraries.all.keys.join("/")})"
    class_option :destination, type: :string, default: "app/assets/svg/icons/", desc: "Custom destination folder for icons (default: `app/assets/svg/icons/`)"
    class_option :skip_sync, type: :boolean, default: false

    def initializer_generator
      generator("rails_icons:initializer")
    end

    def sync_generator
      return if options[:skip_sync]

      generator("rails_icons:sync")
    end

    private

    def generator(name)
      params = [name]
      params += ["--libraries", Array(options[:libraries]).compact.join(",")] if options[:libraries].present?

      generate(*params)
    end
  end
end
