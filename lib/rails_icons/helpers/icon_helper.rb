# frozen_string_literal: true

require_relative "../configuration"

module RailsIcons
  module Helpers
    module IconHelper
      def icon(name, library: RailsIcons.configuration.default_library, from: library, variant: nil, **arguments)
        RailsIcons::Icon.new(
          name: name,
          library: from || library,
          variant: variant,
          arguments: arguments
        ).svg
      end
    end
  end
end
