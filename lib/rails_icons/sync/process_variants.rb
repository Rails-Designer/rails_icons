# frozen_string_literal: true

require "fileutils"
require "rails_icons/sync/transformations"

module RailsIcons
  module Sync
    class ProcessVariants < Rails::Generators::Base
      def initialize(temp_directory, name, library)
        @temp_directory, @name, @library = temp_directory, name, library
      end

      def process
        original_variants = Dir.children(@temp_directory)
        excluded_variants = RailsIcons.configuration.libraries.dig(@name.to_sym)&.exclude_variants || []

        @library[:variants].each do |variant_name, variant_source_path|
          next if excluded_variants.include?(variant_name)

          source = File.join(@temp_directory, variant_source_path)
          destination = File.join(@temp_directory, variant_name.to_s)

          original_variants.delete(variant_name.to_s)

          raise "[Rails Icons] Failed to find the icons directory: '#{source}'" unless Dir.exist?(source)

          move_icons(source, destination)

          apply_transformations_to(destination)
        end

        remove_files_and_folders_for(original_variants)
        remove_previously_downloaded(excluded_variants)

        say "[Rails Icons] Icon variants processed successfully"
      end

      private

      def move_icons(source, destination)
        FileUtils.mkdir_p(destination)

        Dir.each_child(source).each do |item|
          FileUtils.mv(File.join(source, item), destination)
        end
      end

      def apply_transformations_to(destination)
        Dir.each_child(destination) do |filename|
          File.rename(
            File.join(destination, filename),
            File.join(destination, Sync::Transformations.transform(filename, transformations.fetch(:filenames, {})))
          )
        end
      end

      def remove_files_and_folders_for(paths)
        paths.each do |path|
          FileUtils.rm_rf(File.join(@temp_directory, path))
        end
      end

      def remove_previously_downloaded(variants)
        variants.each do |variant|
          FileUtils.rm_rf(File.join(RailsIcons.configuration.destination_path, @name, variant.to_s))
        end
      end

      def transformations
        RailsIcons.libraries.dig(@name.to_sym)&.try(:transformations) || {}
      end
    end
  end
end
