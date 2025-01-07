module RailsIcons
  class Icon
    class FilePath
      def initialize(name:, library:, variant:)
        @name = name
        @library = library
        @variant = variant
      end

      def call
        return animated_icons_path if @library.animated?
        return custom_library_path if @library.custom?

        icon_path = icons_path_in_app || icons_path_in_engines

        raise RailsIcons::NotFound if icon_path.nil?

        icon_path
      end

      private

      def animated_icons_path = RailsIcons::Engine.root.join("app", "assets", "svg", "rails_icons", "icons", "animated", "#{@name}.svg")

      def custom_library_path = Rails.root.join(@library.custom_path, "#{@name}.svg")

      def icons_path_in_app
        path = app_path

        path if File.exist?(path)
      end

      def icons_path_in_engines
        path = nil

        Rails::Engine.subclasses.find do |engine|
          path = engine.root.join(*parts)

          path if File.exist?(path)
        end

        path
      end

      def app_path = Rails.root.join(*parts)

      def parts
        [
          RailsIcons.configuration.destination_path,
          @library,
          @variant,
          "#{@name}.svg"
        ].compact_blank!
      end
    end
  end
end
