# frozen_string_literal: true

module RailsIcons
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
      @config.helper_name = "icon"
      @config.default_library = "heroicons"
      @config.default_set = "outline"
    end

    def set_libraries_config
      @config.libraries = ActiveSupport::OrderedOptions.new

      heroicons_config
      lucide_config
    end

    def heroicons_config
      @config.libraries.heroicons = ActiveSupport::OrderedOptions.new

      @config.libraries.heroicons.solid = ActiveSupport::OrderedOptions.new
      @config.libraries.heroicons.solid.default = ActiveSupport::OrderedOptions.new
      @config.libraries.heroicons.solid.default.css = "w-6 h-6"
      @config.libraries.heroicons.solid.default.data = {}

      @config.libraries.heroicons.outline = ActiveSupport::OrderedOptions.new
      @config.libraries.heroicons.outline.default = ActiveSupport::OrderedOptions.new
      @config.libraries.heroicons.outline.default.stroke_width = 1.5
      @config.libraries.heroicons.outline.default.css = "w-6 h-6"
      @config.libraries.heroicons.outline.default.data = {}

      @config.libraries.heroicons.mini = ActiveSupport::OrderedOptions.new
      @config.libraries.heroicons.mini.default = ActiveSupport::OrderedOptions.new
      @config.libraries.heroicons.mini.default.css = "w-5 h-5"
      @config.libraries.heroicons.mini.default.data = {}

      @config.libraries.heroicons.micro = ActiveSupport::OrderedOptions.new
      @config.libraries.heroicons.micro.default = ActiveSupport::OrderedOptions.new
      @config.libraries.heroicons.micro.default.css = "w-4 h-4"
      @config.libraries.heroicons.micro.default.data = {}
    end

    def lucide_config
      @config.libraries.lucide = ActiveSupport::OrderedOptions.new

      @config.libraries.lucide.outline = ActiveSupport::OrderedOptions.new
      @config.libraries.lucide.outline.default = ActiveSupport::OrderedOptions.new
      @config.libraries.lucide.outline.default.stroke_width = 2
      @config.libraries.lucide.outline.default.css = "w-6 h-6"
      @config.libraries.lucide.outline.default.data = {}
    end
  end
end
