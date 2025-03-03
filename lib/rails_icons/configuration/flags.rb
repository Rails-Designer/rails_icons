# frozen_string_literal: true

module RailsIcons
  class Configuration
    module Flags
      extend self

      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.default_variant = "landscape"
          options.exclude_variants = []

          setup_square_config(options)
          setup_landscape_config(options)
        end
      end

      def initializer_config
        <<~RB.indent(2)
          # Override Flags defaults
          # config.libraries.flags.exclude_variants = [:square, :landscape]

          # config.libraries.flags.square.default.css = "size-6"
          # config.libraries.flags.square.default.data = {}

          # config.libraries.flags.landscape.default.css = "size-6"
          # config.libraries.flags.landscape.default.data = {}
        RB
      end

      def source
        {
          url: "https://github.com/lipis/flag-icons.git",
          variants: {
            square: "flags/1x1",
            landscape: "flags/4x3"
          }
        }
      end

      private

      def setup_square_config(options)
        options.square = ActiveSupport::OrderedOptions.new
        options.square.default = default_square_options
      end

      def setup_landscape_config(options)
        options.landscape = ActiveSupport::OrderedOptions.new
        options.landscape.default = default_landscape_options
      end

      def default_square_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end

      def default_landscape_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end
    end
  end
end
