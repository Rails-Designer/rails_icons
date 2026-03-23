# frozen_string_literal: true

require "fileutils"
require "yaml"

module RailsIcons
  class GenerateTags
    def initialize(library)
      @library = library
    end

    def call
      tags_path = tags_file_path
      existing = load_existing(tags_path)

      icon_names.each do |name|
        existing[name] ||= ""
      end

      FileUtils.mkdir_p(tags_path.dirname)
      File.write(tags_path, YAML.dump(existing).sub("---\n", ""))
    end

    private

    def tags_file_path
      RailsIcons::Engine.root.join("app/models/rails_icons/preview/tags/#{@library}.yml")
    end

    def load_existing(path)
      File.exist?(path) ? YAML.load_file(path) : {}
    end

    def icon_names
      Dir.glob("#{icons_path}/**/*.svg")
        .map { |file| File.basename(file, ".svg") }
        .uniq
    end

    def icons_path
      RailsIcons::Engine.root.join("app/assets/svg/icons/#{@library}")
    end
  end
end
