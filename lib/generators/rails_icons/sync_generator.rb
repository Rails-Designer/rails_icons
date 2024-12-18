# frozen_string_literal: true

require "rails_icons/sync/engine"

module RailsIcons
  class SyncGenerator < Rails::Generators::Base
    class_option :libraries, type: :array, default: [], desc: "Choose libraries (#{RailsIcons.libraries.keys.join("/")})"
    class_option :destination, type: :string, default: "app/assets/svg/icons/", desc: "Specify destination folder for icons"

    desc "Sync an icon library(s) from their respective git repos."
    source_root File.expand_path("templates", __dir__)

    def sync_icons
      raise "[Rails Icons] Not a valid library" if libraries.empty?

      libraries.each { Sync::Engine.new(_1).sync }
    end

    private

    def libraries
      options[:libraries].presence || synced_libraries
    end

    def synced_libraries
      RailsIcons.libraries.keys.map(&:to_s).select do |library|
        Dir.exist?(File.join(RailsIcons.configuration.destination_path, library.to_s))
      end
    end
  end
end
