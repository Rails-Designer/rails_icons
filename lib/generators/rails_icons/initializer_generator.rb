# frozen_string_literal: true

require "rails_icons/base_generator"

module RailsIcons
  class InitializerGenerator < RailsIcons::BaseGenerator
    source_root File.expand_path("templates", __dir__)

    desc "Create the Rails Icons initializer."

    class_option :library, type: :string, desc: "Choose a library (#{RailsIcons.libraries.keys.join("/")})"
    class_option :libraries, type: :array, default: [], desc: "Choose libraries (#{RailsIcons.libraries.keys.join("/")})"
    class_option :destination, type: :string, default: RailsIcons.configuration&.icons_path, desc: "Specify icons folder"
    class_option :custom, type: :string, desc: "Name of the custom library"

    def copy_initializer
      return if File.exist?(INITIALIZER)

      copy_file "initializer.rb", INITIALIZER
    end

    def insert_default_configuration
      return unless File.exist?(INITIALIZER)
      return if default_configuration_exists?

      if libraries.present?
        default_configuration = <<~RB.indent(2)
          config.default_library = "#{libraries.first}"
          # config.default_variant = "" # Set a default variant for all libraries
        RB

        insert_into_file INITIALIZER, default_configuration, after: "RailsIcons.configure do |config|\n"
      end
    end

    def insert_custom_icons_path
      return if options[:destination] == RailsIcons.configuration&.icons_path

      insert_into_file INITIALIZER, <<~RB.indent(2), after: "RailsIcons.configure do |config|\n"
        # Default icons path
        config.icons_path = "#{options[:destination]}"

      RB
    end

    def insert_libraries_configuration
      insert_into_file INITIALIZER, "\n#{library_configuration}", before: "end"
    end

    def setup_custom_configuration
      return if options[:custom].blank?

      insert_custom_configuration
      create_custom_directory
    end

    private

    INITIALIZER = "config/initializers/rails_icons.rb"

    def insert_custom_configuration
      unless file_contains?(INITIALIZER, "config.libraries.merge!")
        custom_default_configuration = <<~RB.indent(2)

          config.libraries.merge!(
          )
        RB

        insert_into_file INITIALIZER, custom_default_configuration, before: "end"
      end

      insert_into_file INITIALIZER, "\n#{custom_configuration}", after: "config.libraries.merge!("
    end

    def create_custom_directory = FileUtils.mkdir_p(File.join(options[:destination], options[:custom]))

    def library_configuration
      libraries.map { |library| RailsIcons.libraries[library.to_sym].initializer_config }.join("\n")
    end

    def custom_configuration
      <<~RB.indent(4)
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

      File.readlines(INITIALIZER).any? { |file_line| file_line.match?(line) }
    end

    def libraries
      [options[:library], *options[:libraries]]
        .compact_blank
        .map(&:downcase)
        .uniq
        .presence || []
    end

    def validatable? = true
  end
end
