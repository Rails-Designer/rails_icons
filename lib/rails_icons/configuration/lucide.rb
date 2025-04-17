# frozen_string_literal: true

module RailsIcons
  class Configuration
    module Lucide
      extend self

      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.default_variant = :outline
          options.exclude_variants = []

          setup_outline_config(options)
        end
      end

      def initializer_config
        <<~RB.indent(2)
          # Override Lucide defaults
          # config.libraries.lucide.default_variant = "" # Set a default variant for Lucide
          # config.libraries.lucide.exclude_variants = [] # Exclude specific variants

          # config.libraries.lucide.outline.default.css = "size-6"
          # config.libraries.lucide.outline.default.stroke_width = "1.5"
          # config.libraries.lucide.outline.default.data = {}
        RB
      end

      def source
        {
          url: "https://github.com/lucide-icons/lucide.git",
          variants: {
            outline: "icons"
          }
        }
      end

      private

      def setup_outline_config(options)
        options.outline = ActiveSupport::OrderedOptions.new
        options.outline.default = default_outline_options
      end

      def default_outline_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.stroke_width = "1.5"
          options.css = "size-6"
          options.data = {}
        end
      end
    end
  end
end
