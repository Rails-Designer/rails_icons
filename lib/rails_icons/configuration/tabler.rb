# frozen_string_literal: true

module RailsIcons
  class Configuration
    module Tabler
      extend self

      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.default_variant = :outline

          setup_outline_config(options)
          setup_filled_config(options)
        end
      end

      def initializer_config
        <<~RB.indent(2)
          # Override Tabler defaults
          # config.libraries.tabler.solid.default.css = "size-6"
          # config.libraries.tabler.solid.default.data = {}

          # config.libraries.tabler.outline.default.css = "size-6"
          # config.libraries.tabler.outline.default.stroke_width = "2"
          # config.libraries.tabler.outline.default.data = {}
        RB
      end

      def source
        {
          url: "https://github.com/tabler/tabler-icons.git",
          variants: {
            filled: "icons/filled",
            outline: "icons/outline"
          }
        }
      end

      private

      def setup_outline_config(options)
        options.outline = ActiveSupport::OrderedOptions.new
        options.outline.default = default_outline_options
      end

      def setup_filled_config(options)
        options.filled = ActiveSupport::OrderedOptions.new
        options.filled.default = default_filled_options
      end

      def default_outline_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.stroke_width = 2
          options.css = "size-6"
          options.data = {}
        end
      end

      def default_filled_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end
    end
  end
end
