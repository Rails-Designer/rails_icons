# frozen_string_literal: true

require "rails_icons/helpers/icon_helper"
require "rails_icons/helpers/sprite_helper"

module RailsIcons
  class Engine < ::Rails::Engine
    isolate_namespace RailsIcons

    initializer "rails_icons.configure_icons_gem", before: :load_config_initializers do
      Icons.configure do |config|
        config.base_path = Rails.root
      end
    end

    initializer "rails_icons.sprite_configuration", before: :load_config_initializers do
      Icons.configure do |config|
        config.sprite = {}
        config.default_sprite_location = "/rails_icons/sprite.svg"
        config.validate_sprite_icons = false
      end
    end

    initializer "rails_icons.mime_types", before: :load_config_initializers do
      Mime::Type.register "image/svg+xml", :svg unless Mime::Type.lookup_by_extension(:svg)
    end

    initializer "rails_icons.sprite_route", after: :load_config_initializers do |app|
      app.routes.prepend do
        get "/rails_icons/sprite.svg",
          to: "rails_icons/sprites#show",
          as: :rails_icons_sprite,
          defaults: {format: :svg}
      end
    end

    initializer "rails_icons.helpers" do
      ActiveSupport.on_load(:action_view) do
        include RailsIcons::Helpers::IconHelper
        include RailsIcons::Helpers::SpriteHelper
      end
    end
  end
end
