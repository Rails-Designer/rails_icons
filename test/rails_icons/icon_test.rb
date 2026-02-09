require "test_helper"

include IconHelper

class IconTest < ActiveSupport::TestCase
  test "it returns an icon SVG through helper" do
    assert_match(/\A<svg.*<\/svg>\z/m, icon("academic-cap"))
  end

  test "`from` alias for `library`" do
    assert_nothing_raised do
      icon("academic-cap", from: "heroicons")
    end
  end

  test "helper with variant" do
    assert_nothing_raised do
      icon("academic-cap", variant: "mini")
    end
  end

  test "encoded_icon helper" do
    result = encoded_icon("academic-cap")
    assert result.start_with?("data:image/svg+xml;base64,")
  end
end
