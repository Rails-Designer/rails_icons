# frozen_string_literal: true

module RailsIcons
  class Sprite
    include ActionView::Helpers::TagHelper

    def initialize(config: RailsIcons.configuration, icons: nil, library: nil, variant: nil)
      @config = config
      @icons = icons
      @library = library
      @variant = variant
    end

    def svg
      symbols = svg_list.filter_map do |icon_name, library_name, variant_name|
        symbol_from_svg(icon_name, library_name, variant_name)
      end

      content = <<~SVG
        <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
          #{symbols.join("\n  ")}
        </svg>
      SVG

      # rubocop:disable Rails/OutputSafety
      content.html_safe
      # rubocop:enable Rails/OutputSafety
    end

    private

    def svg_list
      @icons ? override_svg_list : configured_svg_list
    end

    def override_svg_list
      library = @library || @config.default_library
      variant = @variant || @config.default_variant
      @icons.map do |icon_name|
        [icon_name, library, variant]
      end
    end

    def configured_svg_list
      sprite_config = @config.sprite || {}
      sprite_config.flat_map do |library_name, variants|
        variants.flat_map do |variant_name, icon_names|
          icon_names.map do |icon_name|
            [icon_name, library_name, variant_name]
          end
        end
      end
    end

    def symbol_from_svg(icon_name, library, variant)
      file_path = Icons::Icon::FilePath.new(
        name: icon_name,
        library: library.to_s,
        variant: variant.to_s
      ).call
      return unless File.exist?(file_path)

      svg_content = File.read(file_path)

      doc = Nokogiri::XML(svg_content)
      svg_element = doc.at_css("svg")

      tag.symbol id: id_for(icon_name, library, variant), viewBox: svg_element["viewBox"] || "0 0 24 24" do
        svg_element.children.map(&:to_s).join
      end
    rescue Icons::IconNotFound
      Rails.logger.warn "Icon not found: #{icon_name} from #{library}/#{variant}"
      nil
    end

    def id_for(icon_name, library, variant) = [library, variant, icon_name].join("_")
  end
end
