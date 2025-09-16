# frozen_string_literal: true

module RailsIcons
  class Railtie < Rails::Railtie
    initializer "rails_icons.helpers" do
      ActiveSupport.on_load(:action_view) do
        include RailsIcons::IconHelper
      end
    end
  end
end
