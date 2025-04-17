# frozen_string_literal: true

module RailsIcons
  class Configuration
    module Boxicons
      extend self

      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.default_variant = :regular
          options.exclude_variants = []

          setup_regular_config(options)
          setup_solid_config(options)
          setup_logos_config(options)
        end
      end

      def initializer_config
        <<~RB.indent(2)
          # Override Boxicons defaults
          # config.libraries.boxicons.default_variant = "" # Set a default variant for Boxicons
          # config.libraries.boxicons.exclude_variants = [] # Exclude specific variants

          # config.libraries.boxicons.solid.css = "size-6"
          # config.libraries.boxicons.solid.data = {}

          # config.libraries.boxicons.regular.css = "size-6"
          # config.libraries.boxicons.regular.data = {}

          # config.libraries.boxicons.logos.css = "size-6"
          # config.libraries.boxicons.logos.data = {}
        RB
      end

      def source
        {
          url: "https://github.com/atisawd/boxicons.git",
          variants: {
            logos: "svg/logos",
            regular: "svg/regular",
            solid: "svg/solid"
          }
        }
      end

      def transformations
        {
          filenames: {
            delete_prefix: ["bxl-", "bx-", "bxs-"]
          }
        }
      end

      def setup_regular_config(options)
        options.regular = ActiveSupport::OrderedOptions.new
        options.regular.default = default_options
      end

      def setup_solid_config(options)
        options.solid = ActiveSupport::OrderedOptions.new
        options.solid.default = default_options
      end

      def setup_logos_config(options)
        options.logos = ActiveSupport::OrderedOptions.new
        options.logos.default = default_options
      end

      def default_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end
    end
  end
end
