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

  test "registers the svg mime type" do
    assert Mime::Type.lookup_by_extension(:svg)
  end
end
