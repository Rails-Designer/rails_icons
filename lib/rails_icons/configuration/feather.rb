# frozen_string_literal: true

module RailsIcons
  class Configuration
    module Feather
      extend self

      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.default_variant = nil
          options.exclude_variants = []

          options.default = default_options
        end
      end

      def initializer_config
        <<~RB.indent(2)
          # Override Feather defaults
          # config.libraries.weather.default_variant = "" # Feather has no variants, this is provided for backwards compatibility
          # config.libraries.feather.exclude_variants = [] # Feather has no variants, this is provided for backwards compatibility

          # config.libraries.feather.default.css = "size-6"
          # config.libraries.feather.default.stroke_width = "2"
          # config.libraries.feather.default.data = {}
        RB
      end

      def source
        {
          url: "https://github.com/feathericons/feather.git",
          variants: {
            ".": "icons" # Feather has no variants, store in the top directory
          }
        }
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
