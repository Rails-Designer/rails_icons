# frozen_string_literal: true

require "rails_icons/helpers/icon_helper"

module RailsIcons
  class Railtie < Rails::Railtie
    initializer "rails_icons.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include RailsIcons::Helpers::IconHelper
      end
    end
  end
end
