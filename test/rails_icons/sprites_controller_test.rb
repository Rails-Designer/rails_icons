# frozen_string_literal: true

require "test_helper"

class RailsIcons::SpritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    RailsIcons.configure do |config|
      config.default_library = "heroicons"
      config.default_variant = "outline"
      config.sprite = {
        heroicons: {
          outline: ["academic-cap"]
        }
      }
    end
  end

  test "serves the sprite as image/svg+xml" do
    get "/rails_icons/sprite.svg"

    assert_response :success
    assert_equal "image/svg+xml", response.media_type
    assert_match(/<symbol id="heroicons_outline_academic-cap"/, response.body)
  end

  test "sprite inner content is not html escaped" do
    get "/rails_icons/sprite.svg"

    refute_match(/&lt;/, response.body)
  end

  test "registers the svg mime type" do
    assert Mime::Type.lookup_by_extension(:svg)
  end

  test "sprite route is registered on the host app, not the engine" do
    host_route = Rails.application.routes.routes.find { |route| route.name == "rails_icons_sprite" }
    engine_route = RailsIcons::Engine.routes.routes.find { |route| route.name == "rails_icons_sprite" }

    assert host_route,
      "expected :rails_icons_sprite to be defined on the host application's routes"
    refute engine_route,
      "sprite route must not live inside the engine — it would become unreachable when the engine is mounted under authentication"
  end
end
