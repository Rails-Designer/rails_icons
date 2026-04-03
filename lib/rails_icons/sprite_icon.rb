# frozen_string_literal: true

module RailsIcons
  class SpriteIcon
    def initialize(name:, library:, arguments:, variant:, sprite_location:, config: RailsIcons.configuration)
      @config = config

      @name = name
      @library = library.to_sym
      @variant = (variant || set_variant)&.to_s
      @arguments = arguments
      @sprite_location = sprite_location || @config.default_sprite_location
    end

    def svg
      if @config.validate_sprite_icons
        raise Icons::IconNotFound, error_message unless sprite_icon_exists?
      end

      build_sprite_svg
    end

    private

    def set_variant
      value = @config.libraries.dig(@library, :default_variant) ||
        @config.default_variant

      value.to_s.empty? ? nil : value
    end

    def error_message
      attributes = [
        @library,
        @variant,
        @name
      ].compact_blank

      "Icon not found: `#{attributes.join(" / ")}`"
    end

    def build_sprite_svg
      sprite_href = @sprite_location.nil? ? "##{sprite_symbol_id}" : "#{@sprite_location}##{sprite_symbol_id}"

      svg_content = <<~SVG
        <svg><use href="#{sprite_href}"></use></svg>
      SVG

      # rubocop:disable Rails/OutputSafety
      Nokogiri::HTML::DocumentFragment.parse(svg_content)
        .at_css("svg")
        .tap { |svg| attach_attributes(to: svg) }
        .to_html
        .html_safe
      # rubocop:enable Rails/OutputSafety
    end

    def sprite_icon_exists?
      file_path = Icons::Icon::FilePath.new(
        name: @name,
        library: @library,
        variant: @variant
      ).call
      File.exist?(file_path)
    rescue Icons::IconNotFound
      false
    end

    def sprite_symbol_id
      "#{@library}_#{@variant}_#{@name}"
    end

    def attach_attributes(to:)
      Icons::Icon::Attributes
        .new(default_attributes: default_attributes, arguments: @arguments)
        .attach(to: to)
    end

    def default_attributes
      {
        "stroke-width": default(:stroke_width),
        data: default(:data),
        class: default(:css)
      }.compact
    end

    def default(key) = library_attributes.dig(:default, key)

    def library_attributes
      keys = [@library, @variant&.to_sym].compact
      @config.libraries.dig(*keys) || {}
    end
  end
end
