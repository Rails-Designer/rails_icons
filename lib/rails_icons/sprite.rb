# frozen_string_literal: true

require_relative "sprite/reference"

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
      symbols = references.filter_map { |reference| symbol_from(reference) }

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

    def references
      @icons ? override_references : configured_references
    end

    def override_references
      library = @library || @config.default_library
      variant = @variant || @config.default_variant
      @icons.map { |name| Reference.new(name: name, library: library, variant: variant) }
    end

    def configured_references
      sprite_config = @config.sprite || {}
      sprite_config.flat_map do |library, variants|
        variants.flat_map do |variant, names|
          names.map { |name| Reference.new(name: name, library: library, variant: variant) }
        end
      end
    end

    def symbol_from(reference)
      return unless reference.exists?

      svg_element = Nokogiri::XML(File.read(reference.file_path)).at_css("svg")

      tag.symbol id: reference.id, viewBox: svg_element["viewBox"] || "0 0 24 24" do
        svg_element.children.map(&:to_s).join
      end
    rescue Icons::IconNotFound
      Rails.logger.warn "Icon not found: #{reference.name} from #{reference.library}/#{reference.variant}"
      nil
    end
  end
end
