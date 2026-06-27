# frozen_string_literal: true

require "rails_icons/base_generator"

module RailsIcons
  class SyncGenerator < RailsIcons::BaseGenerator
    source_root File.expand_path("templates", __dir__)

    desc "Sync the chosen icon libraries from their respective git repos."

    class_option :library, type: :string, desc: "Choose a library (#{RailsIcons.libraries.keys.join("/")})"
    class_option :libraries, type: :array, default: [], desc: "Choose libraries (#{RailsIcons.libraries.keys.join("/")})"
    class_option :variants, type: :array, desc: "Only sync specific variants (e.g. solid outline)"

    def sync_icons
      libraries.each { |library| Icons::Sync.new(library, variants: variants).now }
    end

    private

    def variants
      options[:variants]&.map(&:to_sym)
    end

    def libraries
      [options[:library], *options[:libraries]]
        .compact_blank
        .map(&:downcase)
        .uniq
        .presence || synced_libraries
    end

    def synced_libraries
      RailsIcons.libraries.keys.map(&:to_s).select do |library|
        Dir.exist?(File.join(RailsIcons.configuration.icons_path, library.to_s))
      end
    end
  end
end
