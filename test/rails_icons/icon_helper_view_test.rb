require "test_helper"

class IconHelperViewTest < ActionView::TestCase
  test "icon helper is automatically available in views" do
    assert ActionView::Base.instance_methods.include?(:icon), "icon method should be included in ActionView::Base"
  end
end
