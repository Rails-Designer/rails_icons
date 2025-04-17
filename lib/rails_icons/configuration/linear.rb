# frozen_string_literal: true

module RailsIcons
  class Configuration
    module Linear
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
          # Override Linear defaults
          # config.libraries.linear.default_variant = "" # Set a default variant for Linear
          # config.libraries.linear.exclude_variants = []

          # config.libraries.linear.default.css = "size-6"
          # config.libraries.linear.default.stroke_width = "2"
          # config.libraries.linear.default.data = {}
        RB
      end

      def source
        {
          url: "https://github.com/cjpatoilo/linearicons.git",
          variants: {
            ".": "dist/svg" # Linear has no variants, store in the top directory
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
