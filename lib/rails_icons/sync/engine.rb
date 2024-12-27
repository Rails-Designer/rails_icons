# frozen_string_literal: true

require "fileutils"
require "rails_icons/sync/process_variants"

module RailsIcons
  module Sync
    class Engine < Rails::Generators::Base
      def initialize(name)
        super

        raise "[Rails Icons] Not a valid library" if RailsIcons.libraries.keys.exclude?(name.to_sym)

        @temp_directory, @name, @library = File.join(TEMP_DIRECTORY, name), name, RailsIcons.libraries.fetch(name.to_sym).source
      end

      def sync
        clone_repository
        process_variants
        remove_non_svg_files

        move_library

        purge_temp_directory
      rescue => error
        say "[Rails Icons] Failed to sync icons: #{error.message}", :red

        post_error_clean_up

        raise
      end

      private

      TEMP_DIRECTORY = Rails.root.join("tmp/icons").freeze

      def clone_repository
        raise "[Rails Icons] Failed to clone repository" unless system("git clone '#{@library[:url]}' '#{@temp_directory}'")

        say "'#{@name}' repository cloned successfully."
      end

      def process_variants = Sync::ProcessVariants.new(@temp_directory, @name, @library).process

      def remove_non_svg_files
        Pathname.glob("#{@temp_directory}/**/*")
          .select { _1.file? && _1.extname != ".svg" }
          .each(&:delete)

        say "[Rails Icons] Non-SVG files removed successfully"
      end

      def move_library
        destination = File.join(RailsIcons.configuration.destination_path, @name)

        FileUtils.mkdir_p(destination)
        FileUtils.mv(Dir.glob("#{@temp_directory}/*"), destination, force: true)

        say "[Rails Icons] Synced '#{@name}' library successfully #{%w[😃 🎉 ✨].sample}", :green
      end

      def purge_temp_directory = FileUtils.rm_rf(TEMP_DIRECTORY)

      def post_error_clean_up
        if yes?("Do you want to remove the temp files? ('#{@temp_directory}') [y/n]")
          say "[Rails Icons] Cleaning up…"

          FileUtils.rm_rf(@temp_directory)
        else
          say "[Rails Icons] Keeping files at: '#{@temp_directory}'"
        end
      end
    end
  end
end
