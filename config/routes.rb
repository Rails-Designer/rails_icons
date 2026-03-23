# frozen_string_literal: true

RailsIcons::Engine.routes.draw do
  get ":library", to: "previews#show", as: :library
  get ":library/:variant", to: "previews#show", as: :library_variant

  root to: "previews#show"
end
