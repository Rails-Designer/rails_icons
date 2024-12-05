# frozen_string_literal: true

module RailsIcons
  class InitializerGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    class_option :libraries, type: :array, default: [], desc: "Choose libraries (#{RailsIcons::Libraries.all.keys.join("/")})"
    class_option :destination, type: :string, default: "app/assets/svg/icons/", desc: "Specify destination folder for icons"
    class_option :custom, type: :string, desc: "Name of the custom library"

    def copy_initializer
      return if File.exist?(INITIALIZER)

      copy_file "initializer.rb", INITIALIZER
    end

    def insert_default_configuration
      return unless File.exist?(INITIALIZER)
      return if default_configuration_exists?

      if options[:libraries].present?
        default_configuration = <<~RB.indent(2)
          config.default_library = "#{options[:libraries].first}"
          # config.default_variant = "" # Set a default variant if multiple exist
        RB

        insert_into_file INITIALIZER, default_configuration, after: "RailsIcons.configure do |config|\n"
      end
    end

    def insert_libraries_configuration
      insert_into_file INITIALIZER, "\n#{library_configuration}", before: "end"
    end

    def setup_custom_configuration
      return "" if options[:custom].blank?

      insert_custom_configuration
      create_custom_directory
    end

    private

    INITIALIZER = "config/initializers/rails_icons.rb"

    def insert_custom_configuration
      unless File.read(INITIALIZER).include?("config.libraries.merge!")
        custom_default_configuration = <<~RB.indent(2)
          config.libraries.merge!(

            {
              custom: {
              }
            }
          )
        RB

        insert_into_file INITIALIZER, custom_default_configuration, before: "end"
      end

      insert_into_file INITIALIZER, "\n#{custom_configuration}", after: "custom: {"
    end

    def create_custom_directory
      FileUtils.mkdir_p(File.join(options[:destination], options[:custom]))
    end

    def library_configuration
      configs = {
        feather: feather_config,
        heroicons: heroicons_config,
        lucide: lucide_config,
        tabler: tabler_config
      }

      options[:libraries].map { configs[_1.to_sym] }.join("\n")
    end

    def feather_config
      <<~RB.indent(2)
        # Override Feather defaults
        # config.libraries.feather.default.css = "size-6"
        # config.libraries.feather.default.stroke_width = "2"
        # config.libraries.feather.default.data = {}
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

    def custom_configuration
      <<~RB.indent(8)
        #{options[:custom]}: {
          # path: "app/assets/svg/icons/#{options[:custom]}/",
          default: {
            css: "size-6"
          }
        }
      RB
    end

    def default_configuration_exists?
      line = /^\s*config\.default_library\s*=/

      File.readlines(INITIALIZER).any? { _1.match?(line) }
    end
  end
end
