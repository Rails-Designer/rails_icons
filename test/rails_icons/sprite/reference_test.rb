# frozen_string_literal: true

require "test_helper"

class RailsIcons::Sprite::ReferenceTest < ActiveSupport::TestCase
  test "id joins library, variant, and name with underscores" do
    reference = RailsIcons::Sprite::Reference.new(
      name: "check", library: :heroicons, variant: :outline
    )

    assert_equal "heroicons_outline_check", reference.id
  end

  test "file_path resolves through Icons::Icon::FilePath" do
    reference = RailsIcons::Sprite::Reference.new(
      name: "academic-cap", library: "heroicons", variant: "outline"
    )

    assert_match(%r{heroicons/outline/academic-cap\.svg\z}, reference.file_path.to_s)
  end

  test "exists? is true when the icon file is on disk" do
    reference = RailsIcons::Sprite::Reference.new(
      name: "academic-cap", library: "heroicons", variant: "outline"
    )

    assert reference.exists?
  end

  test "exists? is false when the icon file is missing" do
    reference = RailsIcons::Sprite::Reference.new(
      name: "definitely-not-an-icon", library: "heroicons", variant: "outline"
    )

    refute reference.exists?
  end

  test "exists? is false when the library is unknown" do
    reference = RailsIcons::Sprite::Reference.new(
      name: "anything", library: "library-that-does-not-exist", variant: "outline"
    )

    refute reference.exists?
  end
end
