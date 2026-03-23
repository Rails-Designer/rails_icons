# frozen_string_literal: true

module RailsIcons
  class Preview
    module Tags
      def tags(library, variant = nil)
        tags_path = RailsIcons::Engine.root.join("app/models/rails_icons/preview/tags/#{library}.yml")
        return {} unless File.exist?(tags_path)

        YAML.load_file(tags_path) || {}
      end
    end
  end
end
