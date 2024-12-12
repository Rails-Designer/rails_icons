# frozen_string_literal: true

module RailsIcons
  class Configuration
    class Phosphor
      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.default_variant = :bold

          setup_bold_config(options)
          # Others:
          # - duotone
          # - fill
          # - light
          # - regular
          # - thin
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
    end
  end
end
