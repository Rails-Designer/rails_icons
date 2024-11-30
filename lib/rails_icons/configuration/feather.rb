# frozen_string_literal: true

module RailsIcons
  class Configuration
    class Feather
      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          setup_outline_config(options)
        end
      end

      private

      def setup_outline_config(options)
        options.outline = ActiveSupport::OrderedOptions.new
        options.outline.default = default_outline_options
      end

      def default_outline_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.stroke_width = "2"
          options.css = "size-6"
          options.data = {}
        end
      end
    end
  end
end
