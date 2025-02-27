require "rails_icons/icon/file_path"
require "rails_icons/icon/attributes"

class RailsIcons::Icon
  def initialize(name:, library:, arguments:, variant: nil)
    @name = name
    @library = library.to_s.inquiry
    @variant = (variant || set_variant).to_s
    @arguments = arguments
  end

  def svg
    raise RailsIcons::IconNotFound, error_message unless File.exist?(file_path)

    Nokogiri::HTML::DocumentFragment.parse(File.read(file_path))
      .at_css("svg")
      .tap { |svg| attach_attributes(to: svg) }
      .to_html
      .html_safe
  end

  private

  def set_variant
    RailsIcons.configuration.default_variant.presence ||
      RailsIcons.configuration.libraries.dig(@library.to_sym, :default_variant)
  end

  def error_message
    attributes = [
      @library,
      @variant,
      @name
    ].compact_blank

    "Icon not found: `#{attributes.join(" / ")}`"
  end

  def file_path = RailsIcons::Icon::FilePath.new(name: @name, library: @library, variant: @variant).call

  def attach_attributes(to:)
    RailsIcons::Icon::Attributes
      .new(default_attributes: default_attributes, arguments: @arguments)
      .attach(to: to)
  end

  def default_attributes
    {
      "stroke-width": default(:stroke_width),
      data: default(:data),
      class: default(:css)
    }
  end

  def default(key) = library_attributes.dig(:default, key)

  def library_attributes
    custom_library? ? custom_library : RailsIcons.configuration.libraries.dig(@library, @variant) || {}
  end

  def custom_library
    RailsIcons
      .configuration
      .libraries
      &.dig("custom")
      &.dig(@library.to_sym)&.with_defaults(
        {
          path: [RailsIcons.configuration.destination_path, @library].join("/")
        }
      ) || {}
  end

  def custom_library? = custom_library.present?
end
