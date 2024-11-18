# frozen_string_literal: true

require_relative "icon_configs/heroicons_config"
require_relative "icon_configs/lucide_config"
require_relative "icon_configs/tabler_config"

module RailsIcons
  # Configuration defines the available configuration options available for each of the icons sets
  # as well as sets the defaults to heroicons
  class Configuration
    def initialize
      @config = ActiveSupport::OrderedOptions.new

      set_default_config
      set_libraries_config
    end

    def method_missing(method_name, ...)
      if @config.respond_to?(method_name)
        @config.send(method_name, ...)
      else
        super
      end
    end

    def respond_to_missing?(method_name)
      @config.respond_to?(method_name) || super
    end

    private

    def set_default_config
      @config.default_library = "heroicons"
      @config.default_set = "outline"
    end

    def set_libraries_config
      @config.libraries = ActiveSupport::OrderedOptions.new

      @config.libraries.heroicons = HeroiconsConfig.new.config
      @config.libraries.lucide = LucideConfig.new.config
      @config.libraries.tabler = TablerConfig.new.config
    end
  end
end
