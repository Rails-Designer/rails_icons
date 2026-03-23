# frozen_string_literal: true

module RailsIcons
  class PreviewsController < ActionController::Base
    def show
      @libraries = preview.libraries
      @library = params[:library] || RailsIcons.configuration.default_library || @libraries.first
      @default_library = RailsIcons.configuration.default_library
      @default_variant = library_default_variant
      @variant = params[:variant] || @default_variant
      @variants = preview.variants(@library)

      @icon_names = preview.icon_names(@library, @variant)
      @tags = preview.tags(@library, @variant)
    end

    private

    def preview
      @preview ||= Preview.new
    end

    def library_default_variant
      RailsIcons.configuration.libraries[@library.to_sym]&.default_variant ||
        RailsIcons.configuration.default_variant
    end
  end
end
