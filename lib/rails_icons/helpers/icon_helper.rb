# frozen_string_literal: true

module RailsIcons
  module Helpers
    module IconHelper
      # Renders an SVG icon
      #
      # @param name [String] The icon name
      # @param library [String] The icon library (defaults to RailsIcons configuration)
      # @param from [String] Syntactic sugar for a cleanly readable view layer API (preferred over `library`)
      # @param variant [String] The icon variant (optional)
      # @param arguments [Hash] Additional arguments including class, data, stroke_width, etc.
      # @return [ActiveSupport::SafeBuffer] An HTML-safe SVG string
      #
      # @example
      #   <%= icon "chevron-down" %>
      #   <%= icon "search", class: "text-blue-500" %>
      #   <%= icon "check", variant: "solid", library: "heroicons" %>
      #
      def icon(name, library: RailsIcons.configuration.default_library, from: library, variant: nil, **arguments)
        Icons::Icon.new(
          name: name,
          library: from || library,
          variant: variant,
          arguments: arguments
        ).svg.html_safe
      end

      # Returns a base64-encoded data URI for an SVG icon
      #
      # @param name [String] The icon name
      # @param library [String] The icon library (defaults to RailsIcons configuration)
      # @param from [String] Syntactic sugar for a cleanly readable view layer API (preferred over `library`)
      # @param variant [String] The icon variant (optional)
      # @param arguments [Hash] Additional arguments including class, data, stroke_width, etc.
      # @return [String] A base64-encoded data URI string (e.g. "data:image/svg+xml;base64,...")
      #
      # @example
      #   encoded_icon "chevron-down"
      #   # => "data:image/svg+xml;base64,PHN2ZyB4bWxucz0..."
      #
      def encoded_icon(name, library: RailsIcons.configuration.default_library, from: library, variant: nil, **arguments)
        svg_content = Icons::Icon.new(
          name: name,
          library: from || library,
          variant: variant,
          arguments: arguments
        ).svg

        "data:image/svg+xml;base64,#{Base64.strict_encode64(svg_content)}"
      end
    end
  end
end
