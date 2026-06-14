# frozen_string_literal: true

require "icons/sprite_icon"

module RailsIcons
  module Helpers
    module SpriteHelper
      # Renders an SVG icon from a sprite, compatible with Rails Icons API
      #
      # @param name [String] The icon name
      # @param library [String] The icon library (defaults to RailsIcons configuration)
      # @param variant [String] The icon variant (optional)
      # @param sprite_location [String] Override sprite URL (optional)
      # @param arguments [Hash] Additional arguments including class, data, stroke_width, etc.
      #
      # @return [ActiveSupport::SafeBuffer] An HTML-safe SVG string referencing a sprite symbol
      #
      # @example
      #   <%= sprite_icon "chevron-down" %>
      #   <%= sprite_icon "search", class: "text-blue-500" %>
      #   <%= sprite_icon "check", variant: "solid", library: "heroicons" %>
      #   <%= sprite_icon "heart", library: "lucide", data: { controller: "favorite" } %>
      #
      def sprite_icon(name, library: nil, variant: nil, sprite_location: nil, **arguments)
        Icons::SpriteIcon.new(
          name: name,
          library: library || RailsIcons.configuration.default_library,
          variant: variant,
          sprite_location: sprite_location,
          arguments: arguments
        ).svg.html_safe
      end

      # Returns the inline SVG sprite content containing all symbols
      #
      # @param icons [Array<String>] Optional array of icon names to include (defaults to all configured icons)
      # @param library [String] Optional library to use for icons
      # @param variant [String] Optional variant to use for icons
      #
      # @return [ActiveSupport::SafeBuffer] An HTML-safe SVG string containing `<symbol>` elements
      #
      # @example
      #   <%= icons_sprite %>
      #   <%= icons_sprite(["check", "search", "menu"]) %>
      #   <%= icons_sprite(["check", "search"], library: "heroicons", variant: "outline") %>
      #
      def icons_sprite(icons = nil, library: nil, variant: nil)
        Icons::Sprite.new(icons: icons, library: library, variant: variant).svg.html_safe
      end
    end
  end
end
