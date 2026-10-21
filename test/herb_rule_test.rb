# frozen_string_literal: true

require "test_helper"

class HerbRuleTest < Minitest::Test
  def test_custom_rule
    skip "Node.js is not available" unless system("node", "--version", out: File::NULL, err: File::NULL)

    rule_test = File.expand_path("javascript/rails_icons_rule_test.mjs", __dir__)

    assert system("node", "--test", rule_test)
  end
end
