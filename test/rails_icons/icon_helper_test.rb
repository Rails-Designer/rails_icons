require "test_helper"

class IconHelperTest < ActiveSupport::TestCase
  test "icon helper constant is defined" do
    assert defined?(RailsIcons::Helpers::IconHelper)
  end

  test "icon helper can be included in classes" do
    test_class = Class.new { include RailsIcons::Helpers::IconHelper }

    assert test_class.new.respond_to?(:icon)
  end
end
