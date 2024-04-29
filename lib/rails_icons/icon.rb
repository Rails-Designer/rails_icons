require "rails_icons/icon/attributes"

class RailsIcons::Icon
  def initialize(name:, library:, set:, args:)
    @name = name
    @library = library.to_s
    @set = set || default_set
    @args = args
  end

  def svg
    raise RailsIcons::NotFound, error_message unless File.exist?(file_path)

    svg_file = Nokogiri::HTML::DocumentFragment.parse(File.read(file_path)).at_css("svg")

    attach_attributes to: svg_file

    svg_file.to_html.html_safe
  end

  private

  def error_message
    "Icon not found: `#{@library} / #{set} / #{@name}`"
  end

  def file_path
    if custom_library?
      Rails.root.join(custom_path, "#{@name}.svg")
    else
      RailsIcons::Engine
        .root
        .join(RailsIcons.icons_directory, @library, set, "#{@name}.svg")
    end
  end

  def custom_library?
    custom_library.present?
  end

  def custom_path
    custom_library.dig("path") ||
      Rails.root.join("app", "assets", "svg", @library, set)
  end

  def attach_attributes(to:)
    RailsIcons::Icon::Attributes
      .new(default_attributes: default_attributes, args: @args)
      .attach(to: to)
  end

  def custom_library
    RailsIcons
      .configuration
      .libraries
      .dig("custom")
      &.with_indifferent_access
      &.dig(@library, set)
  end

  def default_attributes
    {
      "stroke-width": default_stroke_width,
      class: default_css,
      data: default_data
    }
  end

  def set
    return @set if @set.present?

    RailsIcons.configuration.default_set
  end

  def default_set
    RailsIcons.configuration.libraries.dig(@library.to_sym, :default_set)
  end

  def default_css
    library_set_attributes.dig(:default, :css)
  end

  def default_data
    library_set_attributes.dig(:default, :data)
  end

  def default_stroke_width
    library_set_attributes.dig(:default, :stroke_width)
  end

  def library_set_attributes
    return custom_library || {} if custom_library?

    RailsIcons.configuration.libraries.dig(@library, set) || {}
  end
end
