# frozen_string_literal: true

require "test_helper"
require "generators/rails_icons/initializer_generator"

class InitializerGeneratorTest < Rails::Generators::TestCase
  tests RailsIcons::InitializerGenerator

  destination Rails.root.join("../../tmp/generators")

  setup :prepare_destination

  test "generator creates the initializer with default library" do
    run_generator

    assert_file "config/initializers/rails_icons.rb" do |file|
      refute_match "heroicons", file
      refute_match "tabler", file
    end
  end

  test "generator creates the initializer with heroicons library" do
    run_generator %w[--libraries=heroicons]

    assert_file "config/initializers/rails_icons.rb" do |file|
      assert_match "# Override Heroicon defaults", file
      refute_match "lucide", file
    end
  end

  test "generator creates the initializer with lucide library" do
    run_generator %w[--libraries=lucide]

    assert_file "config/initializers/rails_icons.rb" do |file|
      assert_match "# Override lucide defaults", file
      refute_match "heroicons", file
    end
  end

  test "generator creates the initializer with phosphor library" do
    run_generator %w[--libraries=phosphor]

    assert_file "config/initializers/rails_icons.rb" do |file|
      assert_match "# Override phosphor defaults", file
      refute_match "tabler", file
    end
  end

  test "generator creates the initializer with tabler library" do
    run_generator %w[--libraries=tabler]

    assert_file "config/initializers/rails_icons.rb" do |file|
      assert_match "# Override tabler defaults", file
      refute_match "heroicons", file
    end
  end

  test "generator creates the initializer with lucide and tabler library" do
    run_generator ["--libraries", "lucide", "tabler"]

    assert_file "config/initializers/rails_icons.rb" do |file|
      Rails.logger.debug "File content: #{file}"
      assert_match "# Override lucide defaults", file
      assert_match "# Override tabler defaults", file
      refute_match "heroicons", file
    end
  end

  test "generator correctly downcases the library names" do
    run_generator ["--libraries", "Lucide", "Tabler"]

    assert_file "config/initializers/rails_icons.rb" do |file|
      Rails.logger.debug "File content: #{file}"
      assert_match "lucide", file
      refute_match "Lucide", file
      assert_match "tabler", file
      refute_match "Tabler", file
    end
  end
end
