# frozen_string_literal: true

module RailsIcons
  class SpritesController < ActionController::Base
    def show
      render plain: RailsIcons::Sprite.new.svg, content_type: "image/svg+xml"
    end
  end
end
