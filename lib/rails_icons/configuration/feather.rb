# frozen_string_literal: true

module RailsIcons
  class Configuration
    class Feather
      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.default_variant = nil

          options.default = default_options
        end
      end

      private

      def default_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.stroke_width = "2"
          options.css = "size-6"
          options.data = {}
        end
      end
    end
  end
end
