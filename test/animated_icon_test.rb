require "test_helper"
require "rails_icons/icon"

class AnimatedIconTest < ActiveSupport::TestCase
  test "faded-spinner icon" do
    assert_nothing_raised do
      icon("faded-spinner", library: :animated)
    end
  end

  test "trailing-spinner icon" do
    assert_nothing_raised do
      icon("trailing-spinner", library: :animated)
    end
  end

  test "fading-dots" do
    assert_nothing_raised do
      icon("fading-dots", library: :animated)
    end
  end

  test "bouncing-dots" do
    assert_nothing_raised do
      icon("bouncing-dots", library: :animated)
    end
  end

  private

  def icon(name, library: "animated", variant: "base", **args)
    RailsIcons::Icon.new(name: name, library:, variant:, args:).svg
  end
end
