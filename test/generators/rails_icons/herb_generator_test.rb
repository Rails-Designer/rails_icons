# frozen_string_literal: true

require "test_helper"
require "json"

require "generators/rails_icons/herb_generator"

class HerbGeneratorTest < Rails::Generators::TestCase
  tests RailsIcons::HerbGenerator

  destination Rails.root.join("../../tmp/generators")
  setup :prepare_destination

  test "writes the manifest and the custom rule" do
    run_generator

    assert_file ".herb/icons.json" do |content|
      data = JSON.parse(content)

      assert_equal 1, data["version"]
      assert data["libraries"].key?("animated")
      assert_equal %w[default_library default_variant libraries version], data.keys.sort
    end

    assert_file ".herb/rules/rails-icons.mjs" do |content|
      assert_includes content, 'static ruleName = "rails-icons"'
      assert_includes content, "export default class RailsIconsRule"
    end
  end

  test "does not write into the application root" do
    run_generator

    refute File.exist?(Rails.root.join(".herb/icons.json"))
    refute File.exist?(Rails.root.join(".herb/rules/rails-icons.mjs"))
  end
end
