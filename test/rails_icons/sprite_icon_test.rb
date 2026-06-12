# frozen_string_literal: true

require "test_helper"

class SpriteIconTest < ActiveSupport::TestCase
  setup do
    RailsIcons.configure do |config|
      config.default_library = "heroicons"
      config.default_variant = "outline"
      config.default_sprite_location = nil
      config.validate_sprite_icons = false
    end
  end

  test "renders svg with use href for inline sprite" do
    icon = RailsIcons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: "outline",
      sprite_location: nil,
      arguments: {}
    )
    result = icon.svg

    assert_match(/<svg/, result)
    assert_match(%r{<use href="#heroicons_outline_academic-cap"></use>}, result)
    assert_match(%r{</svg>}, result)
  end

  test "renders svg with external sprite location" do
    icon = RailsIcons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: "outline",
      sprite_location: "/sprite.svg",
      arguments: {}
    )
    result = icon.svg

    assert_match(%r{<use href="/sprite.svg#heroicons_outline_academic-cap"></use>}, result)
  end

  test "uses default sprite location from config" do
    RailsIcons.configure do |config|
      config.default_sprite_location = "/assets/sprites.svg"
    end

    icon = RailsIcons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: "outline",
      sprite_location: nil,
      arguments: {}
    )
    result = icon.svg

    assert_match(%r{<use href="/assets/sprites.svg#heroicons_outline_academic-cap"></use>}, result)
  end

  test "defaults to the gem-served /rails_icons/sprite.svg endpoint" do
    RailsIcons.configure do |config|
      config.default_sprite_location = "/rails_icons/sprite.svg"
    end

    icon = RailsIcons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: "outline",
      sprite_location: nil,
      arguments: {}
    )
    result = icon.svg

    assert_match(%r{<use href="/rails_icons/sprite.svg#heroicons_outline_academic-cap"></use>}, result)
  end

  test "applies css class" do
    icon = RailsIcons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: "outline",
      sprite_location: nil,
      arguments: {class: "text-blue-500"}
    )
    result = icon.svg

    assert_match(/class="text-blue-500"/, result)
  end

  test "applies data attributes" do
    icon = RailsIcons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: "outline",
      sprite_location: nil,
      arguments: {data: {controller: "favorite"}}
    )
    result = icon.svg

    assert_match(/data-controller="favorite"/, result)
  end

  test "uses default variant from config when variant is nil" do
    icon = RailsIcons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: nil,
      sprite_location: nil,
      arguments: {}
    )
    result = icon.svg

    assert_match(%r{#heroicons_outline_academic-cap}, result)
  end

  test "raises IconNotFound when validate_sprite_icons is true and icon missing" do
    RailsIcons.configure do |config|
      config.validate_sprite_icons = true
    end

    icon = RailsIcons::SpriteIcon.new(
      name: "nonexistent-icon",
      library: "heroicons",
      variant: "outline",
      sprite_location: nil,
      arguments: {}
    )

    assert_raises(Icons::IconNotFound) { icon.svg }
  end

  test "does not raise when validate_sprite_icons is false and icon missing" do
    icon = RailsIcons::SpriteIcon.new(
      name: "nonexistent-icon",
      library: "heroicons",
      variant: "outline",
      sprite_location: nil,
      arguments: {}
    )

    assert_nothing_raised { icon.svg }
  end

  test "returns html safe string" do
    icon = RailsIcons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: "outline",
      sprite_location: nil,
      arguments: {}
    )
    result = icon.svg

    assert result.html_safe?
  end
end
