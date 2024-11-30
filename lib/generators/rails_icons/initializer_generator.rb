# frozen_string_literal: true

module RailsIcons
  class InitializerGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    class_option :libraries, type: :array, default: ["heroicons"], desc: "Choose libraries (#{RailsIcons::Libraries.all.keys.join("/")})"

    def copy_initializer
      return if File.exist?(INITIALIZER)

      copy_file "initializer.rb", INITIALIZER
    end

    def insert_default_configuration
      return unless File.exist?(INITIALIZER)
      return if default_configuration_exists?

      default_configuration = <<~RB.indent(2)
        config.default_library = "#{libraries.first}"
        # config.default_variant = "outline"
      RB

      insert_into_file INITIALIZER, default_configuration, after: "RailsIcons.configure do |config|\n"
    end

    def insert_configuration
      insert_into_file INITIALIZER, "\n#{library_configuration}", before: "end"
    end

    private

    INITIALIZER = "config/initializers/rails_icons.rb"

    def library_configuration
      configs = {
        feather: feather_config,
        heroicons: heroicons_config,
        lucide: lucide_config,
        tabler: tabler_config,
        custom: custom_config
      }

      libraries.map { configs[_1.to_sym] }.join("\n")
    end

    def feather_config
      <<~RB.indent(2)
        # Override Feather defaults
        # config.libraries.feather.outline.default.css = "size-6"
        # config.libraries.feather.outline.default.stroke_width = "2"
        # config.libraries.feather.outline.default.data = {}
      RB
    end

    def heroicons_config
      <<~RB.indent(2)
        # Override Heroicon defaults
        # config.libraries.heroicons.outline.default.css = "size-6"
        # config.libraries.heroicons.outline.default.stroke_width = "1.5"
        # config.libraries.heroicons.outline.default.data = {}

        # config.libraries.heroicons.solid.default.css = "size-6"
        # config.libraries.heroicons.solid.default.data = {}

        # config.libraries.heroicons.mini.default.css = "size-5"
        # config.libraries.heroicons.mini.default.data = {}

        # config.libraries.heroicons.micro.default.css = "size-4"
        # config.libraries.heroicons.micro.default.data = {}
      RB
    end

    def lucide_config
      <<~RB.indent(2)
        # Override Lucide defaults
        # config.libraries.lucide.outline.default.css = "size-6"
        # config.libraries.lucide.outline.default.stroke_width = "1.5"
        # config.libraries.lucide.outline.default.data = {}
      RB
    end

    def tabler_config
      <<~RB.indent(2)
        # Override Tabler defaults
        # config.libraries.tabler.solid.default.css = "size-6"
        # config.libraries.tabler.solid.default.data = {}

        # config.libraries.tabler.outline.default.css = "size-6"
        # config.libraries.tabler.outline.default.stroke_width = "2"
        # config.libraries.tabler.outline.default.data = {}
      RB
    end

    def custom_config
      <<~RB.indent(2)
        config.libraries.merge!(
          {
            custom: {
              LIBRARY_NAME: {
                solid: {
                  path: "app/assets/svg/icons/LIBRARY_NAME/#{RailsIcons.configuration.default_variant}/", # optional: the default lookup path is: `app/assets/svg/icons/LIBRARY_NAME/#{RailsIcons.configuration.default_variant}/`
                  default: {
                    css: "size-6"
                  }
                }
              }
            }
          }
        )
      RB
    end

    def libraries
      Array(options[:libraries])
        .flat_map { _1.split(",") }
        .map(&:to_sym) & (RailsIcons::Libraries.all.keys + [:custom])
    end

    def default_configuration_exists?
      line = /^\s*config\.default_library\s*=/

      File.readlines(INITIALIZER).any? { _1.match?(line) }
    end
  end
end
