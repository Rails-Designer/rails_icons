# frozen_string_literal: true

require_relative "../configuration"

module RailsIcons
  module Helpers
    module IconHelper
      def icon(name, library: RailsIcons.configuration.default_library, set: nil, **args)
        RailsIcons::Icon.new(
          name: name,
          library: library,
          set: set,
          args: args
        ).svg
      end
    end
  end
end
