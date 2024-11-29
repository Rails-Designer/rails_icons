# frozen_string_literal: true

require "rails_icons/helpers/icon_helper"

module RailsIcons
  class Railtie < Rails::Railtie
    initializer "rails_icons.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include RailsIcons::Helpers::IconHelper
      end
    end

    initializer "rails_icons.assets" do |app|
      gem_root = Pathname.new(Gem.loaded_specs["rails_icons"].gem_dir)

      app.config.assets.paths << gem_root.join("app", "assets", "svg")
    end
  end
end
