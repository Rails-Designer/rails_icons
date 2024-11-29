# frozen_string_literal: true

module RailsIcons
  class Configuration
    class Heroicons
      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          setup_outline_config(options)
          setup_solid_config(options)
          setup_mini_config(options)
          setup_micro_config(options)
        end
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
