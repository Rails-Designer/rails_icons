# frozen_string_literal: true

require "fileutils"
require "json"
require "pathname"

module RailsIcons
  module Herb
    class Catalog
      VERSION = 1
      MANIFEST_PATH = ".herb/icons.json"
      RULE_PATH = ".herb/rules/rails-icons.mjs"
      ANIMATED_ICONS = %w[
        bouncing-dots
        faded-spinner
        fading-dots
        trailing-spinner
      ].freeze

      attr_reader :warnings

      def self.path = new.path

      def self.write! = new.write!

      def initialize(root: nil)
        @root = Pathname.new((root || RailsIcons.config.base_path || Dir.pwd).to_s).expand_path
        @warnings = []
      end

      def path
        @root.join(MANIFEST_PATH)
      end

      def content
        "#{JSON.pretty_generate(to_h)}\n"
      end

      def write!
        if File.exist?(path) && File.read(path) == content
          return path
        end

        FileUtils.mkdir_p(path.dirname)
        File.write(path, content)

        path
      end

      def to_h
        {
          "version" => VERSION,
          "default_library" => string_or_nil(config.default_library),
          "default_variant" => string_or_nil(config.default_variant),
          "libraries" => libraries
        }
      end

      private

      def config
        @config ||= RailsIcons.config || begin
          Icons.configure {}
          Icons.configuration
        end
      end

      def libraries
        result = {}

        library_names.each do |name|
          path = library_path(name)
          next unless path&.directory?

          variants = variants_for(path)
          next if variants.empty?

          result[name] = {
            "default_variant" => default_variant_for(name, variants),
            "variants" => variants
          }
        end

        result["animated"] = animated_library

        deep_sort(result)
      end

      def library_names
        names = on_disk_library_names

        registered_library_names.each do |name|
          names << name if custom_path_for(name)
        end

        names.uniq.sort
      end

      def on_disk_library_names
        return [] unless icons_root.directory?

        icons_root.children
          .select { |child| child.directory? && !child.basename.to_s.start_with?(".") }
          .map { |child| child.basename.to_s }
      end

      def registered_library_names
        names = []

        names.concat(RailsIcons.libraries.keys) if RailsIcons.libraries.respond_to?(:keys)
        names.concat(library_configs.keys) if library_configs.respond_to?(:keys)

        names.map(&:to_s).uniq
      end

      def library_path(name)
        custom_path = custom_path_for(name)

        if custom_path
          relative = relative_to_root(custom_path)

          unless relative
            add_warning("Skipping #{name}: custom_path is outside the project root")
            return nil
          end

          @root.join(relative)
        else
          icons_root.join(name)
        end
      end

      def add_warning(message)
        @warnings << message unless @warnings.include?(message)
      end

      def custom_path_for(name)
        library = RailsIcons.libraries[name.to_sym] if RailsIcons.libraries.respond_to?(:[])

        if library
          return library.custom_path if library.respond_to?(:custom_path)

          library_config = library.config if library.respond_to?(:config)
          path = custom_path_from(library_config)
          return path if path
        end

        custom_path_from(library_configs[name.to_sym] || library_configs[name])
      end

      def custom_path_from(library_config)
        return unless library_config.respond_to?(:[])

        if library_config.respond_to?(:key?)
          return library_config[:custom_path] if library_config.key?(:custom_path)
          return library_config["custom_path"] if library_config.key?("custom_path")

          nil
        else
          library_config[:custom_path] || library_config["custom_path"]
        end
      end

      def library_configs
        @library_configs ||= config.libraries || {}
      end

      def library_config(name)
        key = if library_configs.respond_to?(:key?)
          if library_configs.key?(name.to_sym)
            name.to_sym
          elsif library_configs.key?(name)
            name
          end
        else
          name.to_sym
        end

        return {} unless key

        value = library_configs[key]
        value.respond_to?(:[]) ? value : {}
      end

      def variants_for(directory)
        direct_svgs = svg_files(directory)
        variant_directories = directory.children
          .select { |child| child.directory? && svg_files(child).any? }
          .sort_by { |child| child.basename.to_s }

        variants = {}

        if direct_svgs.any?
          path = relative_to_root(directory)
          variants["default"] = {"path" => path} if path
        end

        variant_directories.each do |variant_directory|
          path = relative_to_root(variant_directory)
          next unless path

          variants[variant_directory.basename.to_s] = {"path" => path}
        end

        variants
      end

      def svg_files(directory)
        return [] unless directory.directory?

        directory.children.select do |child|
          child.file? && child.extname == ".svg"
        end
      end

      def default_variant_for(name, variants)
        return nil if variants.keys == ["default"]

        library_config = library_config(name)
        variant = config_value(library_config, :default_variant)
        variant ||= config_value(library_config, "default_variant")
        variant = string_or_nil(variant)

        variants.key?(variant) ? variant : nil
      end

      def config_value(config, key)
        return unless config.respond_to?(:[])

        if config.respond_to?(:key?)
          config[key] if config.key?(key)
        else
          config[key]
        end
      end

      def animated_library
        {
          "default_variant" => nil,
          "variants" => {
            "default" => {"names" => ANIMATED_ICONS.sort}
          }
        }
      end

      def icons_path
        path = Pathname.new(config.icons_path.to_s)
        relative_to_root(path) || path.to_s
      end

      def icons_root
        @icons_root ||= @root.join(icons_path)
      end

      def relative_to_root(path)
        path = Pathname.new(path.to_s)
        absolute = path.absolute? ? path : @root.join(path.to_s)
        relative = absolute.expand_path.relative_path_from(@root)
        relative = relative.to_s.tr(File::SEPARATOR, "/")

        return nil if relative == ".." || relative.start_with?("../")

        relative
      rescue ArgumentError
        nil
      end

      def string_or_nil(value)
        return if value.nil?

        value.to_s
      end

      def deep_sort(value)
        case value
        when Hash
          value.keys.sort.each_with_object({}) do |key, sorted|
            sorted[key] = deep_sort(value[key])
          end
        when Array
          value.map { |item| deep_sort(item) }
        else
          value
        end
      end
    end
  end
end
