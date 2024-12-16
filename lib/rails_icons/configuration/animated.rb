# frozen_string_literal: true

module RailsIcons
  class Configuration
    module Animated
      extend self

      def config
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.default = default_options
        end
      end

      private

      def default_options
        ActiveSupport::OrderedOptions.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end
    end
  end
end
