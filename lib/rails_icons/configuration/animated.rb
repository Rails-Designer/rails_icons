# frozen_string_literal: true

module RailsIcons
  class Configuration
    class Animated
      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          setup_config(options)
        end
      end

      private

      def setup_config(options)
        options.base = ActiveSupport::OrderedOptions.new
        options.base.default = default_options
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
