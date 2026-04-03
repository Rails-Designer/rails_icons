# frozen_string_literal: true

require "test_helper"

class SpriteTest < ActiveSupport::TestCase
  setup do
    RailsIcons.configure do |config|
      config.default_library = "heroicons"
      config.default_variant = "outline"
    end
  end

  test "generates sprite with configured icons" do
    RailsIcons.configure do |config|
      config.sprite = {
        heroicons: {
          outline: ["academic-cap"]
        }
      }
    end

    sprite = RailsIcons::Sprite.new
    result = sprite.svg

    assert_match(/<svg xmlns/, result)
    assert_match(/style="display: none;"/, result)
    assert_match(/<symbol id="heroicons_outline_academic-cap"/, result)
    assert_match(/viewBox/, result)
  end

  test "generates sprite with override icons array" do
    sprite = RailsIcons::Sprite.new(icons: ["academic-cap"], library: "heroicons", variant: "outline")
    result = sprite.svg

    assert_match(/<symbol id="heroicons_outline_academic-cap"/, result)
  end

  test "generates empty sprite when no icons configured" do
    RailsIcons.configure do |config|
      config.sprite = {}
    end

    sprite = RailsIcons::Sprite.new
    result = sprite.svg

    assert_match(/<svg xmlns/, result)
    assert_no_match(/<symbol/, result)
  end

  test "skips icons that do not exist" do
    sprite = RailsIcons::Sprite.new(icons: ["nonexistent-icon"], library: "heroicons", variant: "outline")
    result = sprite.svg

    assert_match(/<svg xmlns/, result)
    assert_no_match(/<symbol/, result)
  end

  test "generates multiple symbols" do
    RailsIcons.configure do |config|
      config.sprite = {
        heroicons: {
          outline: ["academic-cap"],
          mini: ["academic-cap"]
        }
      }
    end

    sprite = RailsIcons::Sprite.new
    result = sprite.svg

    assert_match(/<symbol id="heroicons_outline_academic-cap"/, result)
    assert_match(/<symbol id="heroicons_mini_academic-cap"/, result)
  end

  test "uses default library and variant for override icons" do
    sprite = RailsIcons::Sprite.new(icons: ["academic-cap"])
    result = sprite.svg

    assert_match(/<symbol id="heroicons_outline_academic-cap"/, result)
  end

  test "returns html safe string" do
    sprite = RailsIcons::Sprite.new(icons: ["academic-cap"], library: "heroicons", variant: "outline")
    result = sprite.svg

    assert result.html_safe?
  end
end
