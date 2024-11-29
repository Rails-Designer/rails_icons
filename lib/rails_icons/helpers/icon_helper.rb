# frozen_string_literal: true

require_relative "../configuration"

module RailsIcons
  module Helpers
    module IconHelper
      def icon(name, library: RailsIcons.configuration.default_library, set: nil, variant: nil, **args)
        RailsIcons::Icon.new(
          name: name,
          library: library,
          variant: variant.to_s || set.to_s,
          args: args
        ).svg
      end
    end
  end
end
