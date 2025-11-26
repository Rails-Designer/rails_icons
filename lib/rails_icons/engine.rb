# frozen_string_literal: true

require "rails_icons/helpers/icon_helper"

module RailsIcons
  class Engine < ::Rails::Engine
    isolate_namespace RailsIcons

    initializer "rails_icons.helpers" do
      ActiveSupport.on_load(:action_view) do
        include RailsIcons::Helpers::IconHelper
      end
    end
  end
end
