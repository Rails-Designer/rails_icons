# frozen_string_literal: true

require "rails_icons/sync/engine"

module RailsIcons
  class SyncGenerator < Rails::Generators::Base
    class_option :libraries, type: :array, default: [], desc: "Choose libraries (#{RailsIcons::Libraries.all.keys.join("/")})"
    class_option :destination, type: :string, default: "app/assets/svg/icons/", desc: "Specify destination folder for icons"

    desc "Sync an icon library(s) from their respective git repos."
    source_root File.expand_path("templates", __dir__)

    def sync_icons
      raise "[Rails Icons] Not a valid library" if options[:libraries].empty?

      options[:libraries].each { Sync::Engine.new(_1).sync }
    end
  end
end
