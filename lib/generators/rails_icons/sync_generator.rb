# frozen_string_literal: true

require "rails_icons/base_generator"
require "rails_icons/sync/engine"

module RailsIcons
  class SyncGenerator < RailsIcons::BaseGenerator
    source_root File.expand_path("templates", __dir__)

    desc "Sync the chosen icon libraries from their respective git repos."

    class_option :libraries, type: :array, default: [], desc: "Choose libraries (#{RailsIcons.libraries.keys.join("/")})"

    def sync_icons = libraries.each { Sync::Engine.new(_1).sync }

    private

    def libraries
      options[:libraries].map(&:downcase).presence || synced_libraries
    end

    def synced_libraries
      RailsIcons.libraries.keys.map(&:to_s).select do |library|
        Dir.exist?(File.join(RailsIcons.configuration.destination_path, library.to_s))
      end
    end
  end
end
