# frozen_string_literal: true

require "fileutils"
require_relative "sync/engine"

module RailsIcons
  class SyncGenerator < Rails::Generators::Base
    class_option :libraries, type: :array, default: ["heroicons"], desc: "Choose libraries (#{RailsIcons::Libraries.all.keys.join("/")})"
    class_option :destination, type: :string, default: "app/assets/svg/icons/", desc: "Custom destination folder for icons (default: `app/assets/svg/icons/`)"

    desc "Sync an icon library(s) from their respective git repos."
    source_root File.expand_path("templates", __dir__)

    def sync_icons
      raise "[Rails Icons] Not a valid library" if libraries.empty?

      clean_temp_directory

      libraries.each { |library| sync(library) }

      clean_temp_directory
    end

    private

    def clean_temp_directory
      FileUtils.rm_rf(temp_directory) if Dir.exist?(temp_directory)
    end

    def libraries
      Array(options[:libraries])
        .flat_map { |library| library.split(",") }
        .map(&:to_sym) & RailsIcons::Libraries.all.keys
    end

    def sync(name)
      library = RailsIcons::Libraries.all.fetch(name.to_sym)
      library_path = File.join(temp_directory, library[:name])

      Sync::Engine.new(temp_directory, library).sync

      raise_library_not_found(name) unless Dir.exist?(library_path)
      copy_library(library[:name], library_path)
    end

    def temp_directory
      Rails.root.join("tmp/icons")
    end

    def copy_library(library, source)
      destination = File.join(options[:destination], library)

      FileUtils.mkdir_p(destination)

      FileUtils.cp_r(Dir.glob("#{source}/*"), destination)

      say "[Rails Icons] Synced '#{library}' library successfully #{%w[😃 🎉 ✨].sample}", :green
    end

    def raise_library_not_found(library)
      say "[Rails Icons] Could not find '#{library}' library 🤷", :red
      exit 1
    end
  end
end
