# frozen_string_literal: true

module RailsIcons
  class SpritesController < ActionController::Base
    def show
      expires_in RailsIcons.sprite_cache_expires_in, public: true

      respond_to do |format|
        format.svg { render plain: Icons::Sprite.new.svg, content_type: "image/svg+xml" }
      end
    end
  end
end
