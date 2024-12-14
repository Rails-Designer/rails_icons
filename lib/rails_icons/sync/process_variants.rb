# frozen_string_literal: true

require "fileutils"

module RailsIcons
  module Sync
    class ProcessVariants < Rails::Generators::Base
      def initialize(temp_directory, library)
        @temp_directory, @library = temp_directory, library
      end

      def process
        original_variants = Dir.children(@temp_directory)

        @library[:variants].each do |variant_name, variant_source_path|
          source = File.join(@temp_directory, variant_source_path)
          destination = File.join(@temp_directory, variant_name.to_s)

          original_variants.delete(variant_name.to_s)

          raise "[Rails Icons] Failed to find the icons directory: '#{source}'" unless Dir.exist?(source)

          move_icons(source, destination)
        end

        remove_files_and_folders(original_variants)

        say "[Rails Icons] Icon variants processed successfully"
      end

      private

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
