# frozen_string_literal: true

require "test_helper"
require "fileutils"
require "minitest/mock"
require "tmpdir"

class HerbCatalogTest < ActiveSupport::TestCase
  setup do
    @config = RailsIcons.config
    @original = {
      base_path: @config.base_path,
      icons_path: @config.icons_path,
      default_library: @config.default_library,
      default_variant: @config.default_variant
    }
    @original_libraries = @config.libraries.deep_dup

    @root = Pathname.new(Dir.mktmpdir("rails-icons-catalog"))
    @config.base_path = @root
    @config.icons_path = "app/assets/svg/icons"
    @config.default_library = "heroicons"
    @config.default_variant = "outline"
  end

  teardown do
    @original.each { |name, value| @config.public_send("#{name}=", value) }
    @config.libraries.replace(@original_libraries)
    FileUtils.remove_entry(@root) if @root.exist?
  end

  test "uses configured defaults and multi-variant libraries" do
    write_icon(icon_path("heroicons/outline/check.svg"))
    write_icon(icon_path("heroicons/solid/check.svg"))

    data = catalog.to_h

    assert_equal "heroicons", data["default_library"]
    assert_equal "outline", data["default_variant"]
    assert_equal "outline", data["libraries"]["heroicons"]["default_variant"]
    assert_equal %w[outline solid], data["libraries"]["heroicons"]["variants"].keys
    assert_equal "app/assets/svg/icons/heroicons/outline",
      data["libraries"]["heroicons"]["variants"]["outline"]["path"]
  end

  test "uses the per-library default variant" do
    @config.libraries[:heroicons] = {default_variant: :solid}
    write_icon(icon_path("heroicons/outline/check.svg"))
    write_icon(icon_path("heroicons/solid/check.svg"))

    assert_equal "solid", catalog.to_h["libraries"]["heroicons"]["default_variant"]
  end

  test "supports libraries without variants" do
    write_icon(icon_path("feather/activity.svg"))

    data = catalog.to_h
    library = data["libraries"]["feather"]

    assert_nil library["default_variant"]
    assert_equal ["default"], library["variants"].keys
    assert_equal "app/assets/svg/icons/feather", library["variants"]["default"]["path"]
  end

  test "supports mixed libraries with direct icons and variant directories" do
    write_icon(icon_path("mixed/root.svg"))
    write_icon(icon_path("mixed/solid/nested.svg"))

    assert_equal %w[default solid], catalog.to_h["libraries"]["mixed"]["variants"].keys
  end

  test "supports custom libraries with a custom path" do
    custom_path = @root.join("vendor/simple_icons")
    write_icon(custom_path.join("apple.svg"))
    @config.libraries[:simple_icons] = {custom_path: custom_path.to_s}

    data = catalog.to_h

    assert_equal "vendor/simple_icons",
      data["libraries"]["simple_icons"]["variants"]["default"]["path"]
  end

  test "supports a custom icons path" do
    @config.icons_path = "assets/icons"
    write_icon(@root.join("assets/icons/feather/activity.svg"))

    data = catalog.to_h

    assert_equal "assets/icons/feather",
      data["libraries"]["feather"]["variants"]["default"]["path"]
  end

  test "includes animated icons" do
    data = catalog.to_h
    animated = data["libraries"]["animated"]

    assert_nil animated["default_variant"]
    assert_equal RailsIcons::Herb::Catalog::ANIMATED_ICONS.sort,
      animated["variants"]["default"]["names"]
  end

  test "skips missing and empty icon directories" do
    assert_equal ["animated"], catalog.to_h["libraries"].keys

    FileUtils.mkdir_p(icon_path("empty"))

    assert_equal ["animated"], catalog.to_h["libraries"].keys
  end

  test "skips custom paths outside the project root" do
    outside = Pathname.new(Dir.mktmpdir("rails-icons-outside"))
    write_icon(outside.join("icon.svg"))
    @config.libraries[:outside] = {custom_path: outside.to_s}

    result = catalog

    refute result.to_h["libraries"].key?("outside")
    assert_includes result.warnings, "Skipping outside: custom_path is outside the project root"
  ensure
    FileUtils.remove_entry(outside) if outside&.exist?
  end

  test "output is deterministic" do
    write_icon(icon_path("zebra/outline/z.svg"))
    write_icon(icon_path("alpha/outline/a.svg"))

    first = catalog.to_h
    second = catalog.to_h

    assert_equal first, second
    assert_equal first["libraries"].keys.sort, first["libraries"].keys
    refute_includes JSON.generate(first), "generated_at"
    refute_includes JSON.generate(first), "timestamp"
  end

  test "writes only the manifest fields the rule uses" do
    assert_equal %w[default_library default_variant libraries version],
      catalog.to_h.keys.sort
  end

  test "writes a newline-terminated catalog and does not rewrite unchanged content" do
    write_icon(icon_path("feather/activity.svg"))

    result = catalog
    result.write!

    assert File.exist?(result.path)
    assert result.warnings.empty?
    assert result.path.read.end_with?("\n")

    File.stub(:write, ->(*) { flunk "catalog was rewritten" }) do
      assert_equal result.path, result.write!
    end
  end

  private

  def catalog
    RailsIcons::Herb::Catalog.new
  end

  def icon_path(*parts)
    @root.join("app/assets/svg/icons", *parts)
  end

  def write_icon(path)
    FileUtils.mkdir_p(path.dirname)
    File.write(path, "<svg/>")
  end
end
