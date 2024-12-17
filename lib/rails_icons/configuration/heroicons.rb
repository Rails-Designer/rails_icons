# frozen_string_literal: true

module RailsIcons
  class Configuration
    module Heroicons
      extend self

      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.default_variant = :outline

          setup_outline_config(options)
          setup_solid_config(options)
          setup_mini_config(options)
          setup_micro_config(options)
        end
      end

      def initializer_config
        <<~RB.indent(2)
          # Override Heroicon defaults
          # config.libraries.heroicons.outline.default.css = "size-6"
          # config.libraries.heroicons.outline.default.stroke_width = "1.5"
          # config.libraries.heroicons.outline.default.data = {}

          # config.libraries.heroicons.solid.default.css = "size-6"
          # config.libraries.heroicons.solid.default.data = {}

          # config.libraries.heroicons.mini.default.css = "size-5"
          # config.libraries.heroicons.mini.default.data = {}

          # config.libraries.heroicons.micro.default.css = "size-4"
          # config.libraries.heroicons.micro.default.data = {}
        RB
      end

      def source
        {
          url: "https://github.com/tailwindlabs/heroicons.git",
          variants: {
            outline: "optimized/24/outline",
            solid: "optimized/24/solid",
            mini: "optimized/20/solid",
            micro: "optimized/16/solid"
          }
        }
      end

      private

      def setup_outline_config(options)
        options.outline = ActiveSupport::OrderedOptions.new
        options.outline.default = default_outline_options
      end

      def setup_solid_config(options)
        options.solid = ActiveSupport::OrderedOptions.new
        options.solid.default = default_solid_options
      end

      def setup_mini_config(options)
        options.mini = ActiveSupport::OrderedOptions.new
        options.mini.default = default_mini_options
      end

      def setup_micro_config(options)
        options.micro = ActiveSupport::OrderedOptions.new
        options.micro.default = default_micro_options
      end

      def default_solid_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end

      def default_outline_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.stroke_width = 1.5
          options.css = "size-6"
          options.data = {}
        end
      end

      def default_mini_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-5"
          options.data = {}
        end
      end

      def default_micro_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-4"
          options.data = {}
        end
      end
    end
  end
end
