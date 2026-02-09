# frozen_string_literal: true

module RailsIcons
  module Helpers
    module IconHelper
      def icon(name, library: RailsIcons.configuration.default_library, from: library, variant: nil, **arguments)
        Icons::Icon.new(
          name: name,
          library: from || library,
          variant: variant,
          arguments: arguments
        ).svg.html_safe
      end

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
