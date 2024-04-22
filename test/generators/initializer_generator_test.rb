# frozen_string_literal: true

require "test_helper"
require "generators/rails_icons/initializer_generator"

class InitializerGeneratorTest < Rails::Generators::TestCase
  tests RailsIcons::InitializerGenerator

  destination Rails.root.join("../../tmp/generators")

  setup :prepare_destination

  test "generator creates an initializer" do
    run_generator

    assert_file "config/initializers/rails_icons.rb"
  end
end
