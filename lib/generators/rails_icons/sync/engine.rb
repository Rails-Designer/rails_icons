# frozen_string_literal: true

require "fileutils"

module RailsIcons
  module Sync
    class Engine < Rails::Generators::Base
      def initialize(temp_icons_directory, library)
        super

        @temp_directory, @library = File.join(temp_icons_directory, library[:name]), library
      end

      def sync
        clone
        filter_variants_from_directory
        remove_non_svg_files
      rescue => error
        say "[Rails Icons] Failed to sync icons: #{error.message}", :red

        clean_up

        raise
      end

      private

      def clone
        raise "[Rails Icons] Failed to clone repository" unless system("git clone '#{@library[:url]}' '#{@temp_directory}'")

        say "#{@library[:name]} repository cloned successfully."
      end

      def filter_variants_from_directory
        original_set_list = Dir.children(@temp_directory)

        @library[:variants].each do |variant_name, variant_source_path|
          source = File.join(@temp_directory, variant_source_path)
          destination = File.join(@temp_directory, variant_name.to_s)

          # Whitelist variant directory if present in original_set_list to prevent deletion
          original_set_list.delete(variant_name.to_s)

          raise "[Rails Icons] Failed to find the icons directory: '#{source}'" unless Dir.exist?(source)

          move_icons(source, destination)
        end

        remove_files_and_folders(original_set_list)

        say "[Rails Icons] Icon variants filtered successfully"
      end

      def remove_non_svg_files
        Pathname.glob("#{@temp_directory}/**/*")
          .select { |p| p.file? && p.extname != ".svg" }
          .each(&:delete)

        say "[Rails Icons] Non-SVG files removed successfully"
      end

      def clean_up
        if yes?("Do you want to remove the temp files? ('#{@temp_directory}')")
          say "[Rails Icons] Cleaning up…"

          FileUtils.rm_rf(@temp_directory)
        else
          say "[Rails Icons] Keeping files at: '#{@temp_directory}'"
        end
      end

      def move_icons(source, destination)
        FileUtils.mkdir_p(destination)

        Dir.children(source).each do |item|
          FileUtils.mv(File.join(source, item), destination)
        end
      end

      def remove_files_and_folders(paths)
        paths.each do |path|
          FileUtils.rm_rf(File.join(@temp_directory, path))
        end
      end
    end
  end
end
