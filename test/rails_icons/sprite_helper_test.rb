# frozen_string_literal: true

require "test_helper"

class SpriteHelperTest < ActiveSupport::TestCase
  include RailsIcons::Helpers::SpriteHelper

  setup do
    RailsIcons.configure do |config|
      config.default_library = "heroicons"
      config.default_variant = "outline"
      config.default_sprite_location = nil
      config.validate_sprite_icons = false
    end
  end

  test "sprite_icon renders an svg use element" do
    result = sprite_icon("academic-cap")

    assert_match(/<svg/, result)
    assert_match(%r{<use href="#heroicons_outline_academic-cap"></use>}, result)
  end

  test "sprite_icon with library and variant" do
    result = sprite_icon("academic-cap", library: "heroicons", variant: "mini")

    assert_match(%r{#heroicons_mini_academic-cap}, result)
  end

  test "sprite_icon with class" do
    result = sprite_icon("academic-cap", class: "size-6")

    assert_match(/class="size-6"/, result)
  end

  test "sprite_icon with sprite_location" do
    result = sprite_icon("academic-cap", sprite_location: "/sprite.svg")

    assert_match(%r{<use href="/sprite.svg#heroicons_outline_academic-cap"></use>}, result)
  end

  test "sprite generates inline svg with symbols" do
    result = sprite(["academic-cap"], library: "heroicons", variant: "outline")

    assert_match(/<svg xmlns/, result)
    assert_match(/<symbol id="heroicons_outline_academic-cap"/, result)
  end

  test "sprite with no arguments uses configured icons" do
    RailsIcons.configure do |config|
      config.sprite = {
        heroicons: {
          outline: ["academic-cap"]
        }
      }
    end

    result = sprite

    assert_match(/<symbol id="heroicons_outline_academic-cap"/, result)
  end
end
