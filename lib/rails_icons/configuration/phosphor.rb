# frozen_string_literal: true

module RailsIcons
  class Configuration
    class Phosphor
      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.default_variant = :regular

          setup_bold_config(options)
          setup_duotone_config(options)
          setup_fill_config(options)
          setup_light_config(options)
          setup_regular_config(options)
          setup_thin_config(options)
        end
      end

      private

      def setup_bold_config(options)
        options.bold = ActiveSupport::OrderedOptions.new
        options.bold.default = default_bold_options
      end

      def default_bold_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end

      def setup_duotone_config(options)
        options.duotone = ActiveSupport::OrderedOptions.new
        options.duotone.default = default_duotone_options
      end

      def default_duotone_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end

      def setup_fill_config(options)
        options.fill = ActiveSupport::OrderedOptions.new
        options.fill.default = default_fill_options
      end

      def default_fill_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end

      def setup_light_config(options)
        options.light = ActiveSupport::OrderedOptions.new
        options.light.default = default_light_options
      end

      def default_light_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end

      def setup_regular_config(options)
        options.regular = ActiveSupport::OrderedOptions.new
        options.regular.default = default_regular_options
      end

      def default_regular_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end

      def setup_thin_config(options)
        options.thin = ActiveSupport::OrderedOptions.new
        options.thin.default = default_thin_options
      end

      def default_thin_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end
    end
  end
end
