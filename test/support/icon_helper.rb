module IconHelper
  def icon(name, library: "heroicons", variant: nil, **arguments)
    Icons::Icon.new(name: name, library:, variant:, arguments:).svg
  end

  def encoded_icon(name, library: "heroicons", from: library, variant: nil, **arguments)
    svg_content = Icons::Icon.new(name: name, library: from || library, variant: variant, arguments: arguments).svg

    "data:image/svg+xml;base64,#{Base64.strict_encode64(svg_content)}"
  end
end
