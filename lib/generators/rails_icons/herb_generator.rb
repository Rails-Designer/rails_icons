# frozen_string_literal: true

require "rails/generators"

require "rails_icons/herb/catalog"

module RailsIcons
  class HerbGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc "Write the Herb manifest and custom rule for validating icon names."

    def write_manifest
      identical = File.exist?(catalog.path) && File.read(catalog.path) == catalog.content
      catalog.write!

      say_status(identical ? :identical : :create, relative_path(catalog.path))
    end

    def write_rule
      content = File.read(File.expand_path("templates/rails-icons.mjs", __dir__))
      destination = File.join(destination_root, RailsIcons::Herb::Catalog::RULE_PATH)

      if File.exist?(destination) && File.read(destination) == content
        say_status :identical, RailsIcons::Herb::Catalog::RULE_PATH
      else
        FileUtils.mkdir_p(File.dirname(destination))
        File.write(destination, content)
        say_status :create, RailsIcons::Herb::Catalog::RULE_PATH
      end
    end

    def print_instructions
      say ""
      say "Herb files written. To enable icon validation:"
      say "  1. Run the linter: npx @herb-tools/linter app/views"
      say "  2. Commit .herb/icons.json and .herb/rules/rails-icons.mjs"
      say ""
      say "The language server picks up the custom rule automatically. Re-run this generator after syncing icons."
    end

    private

    def catalog
      @catalog ||= RailsIcons::Herb::Catalog.new(root: destination_root)
    end

    def relative_path(path)
      Pathname.new(path).relative_path_from(Pathname.new(destination_root)).to_s
    end
  end
end
