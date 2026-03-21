require "test_helper"
require "prism"

module RubyLsp
  class Addon
    def name = raise
    def version = raise
  end

  module Requests
    module Support
      module Common; end
    end
  end

  module Interface
    Range = Struct.new(:start, :end)
    Position = Struct.new(:line, :character)
    TextEdit = Struct.new(:range, :new_text)
    CompletionItem = Struct.new(:label, :kind, :text_edit)
  end

  module Constant
    module CompletionItemKind
      VALUE = 12
    end
  end
end

module RequireStub
  def require(path)
    return true if path == "ruby_lsp/addon"
    return true if path == "ruby_lsp"

    super
  end
end

Kernel.prepend(RequireStub)
require_relative "../../../lib/ruby_lsp/rails_icons/addon"

class RubyLsp::RailsIcons::Addon
  attr_reader :workspace_path
end

class RubyLspRailsIconsAddonTest < ActiveSupport::TestCase
  test "addon is defined" do
    assert defined?(RubyLsp::RailsIcons::Addon)
  end

  test "addon has name" do
    assert_equal "Rails Icons", RubyLsp::RailsIcons::Addon.new.name
  end

  test "addon has version" do
    assert_equal RailsIcons::VERSION, RubyLsp::RailsIcons::Addon.new.version
  end

  test "index_icons returns sorted icon names" do
    addon = RubyLsp::RailsIcons::Addon.new
    addon.instance_variable_set(:@workspace_path, Rails.root.to_s)
    icons = addon.send(:index_icons)

    assert icons.is_a?(Array)
    assert_equal icons.sort, icons
  end

  test "index_icons dedupes icon names" do
    addon = RubyLsp::RailsIcons::Addon.new
    addon.instance_variable_set(:@workspace_path, Rails.root.to_s)
    icons = addon.send(:index_icons)

    assert_equal icons.uniq, icons
  end

  test "index_icons finds icons in fixture directory" do
    addon = RubyLsp::RailsIcons::Addon.new
    addon.instance_variable_set(:@workspace_path, Rails.root.to_s)
    icons = addon.send(:index_icons)

    assert icons.any?, "Expected some icons from fixture directory"
    assert_includes icons, "thumbs-up", "Expected thumbs-up icon from tabler"
  end

  test "addon can be activated without errors" do
    addon = RubyLsp::RailsIcons::Addon.new

    addon.instance_variable_set(:@workspace_path, Rails.root.to_s)
    addon.activate(MockGlobalState.new, Queue.new)

    assert_equal Rails.root.to_s, addon.workspace_path
  end
end

class RubyLspRailsIconsCompletionTest < ActiveSupport::TestCase
  test "completion item generated for matching icon" do
    code = 'icon("thumbs-up")'
    node = Prism.parse(code).value.statements.body.first

    assert_equal :icon, node.name

    response_builder = []
    dispatcher = MockDispatcher.new

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up thumbs-down arrow],
      "/tmp/icons",
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    assert_equal 1, response_builder.size
    assert_equal "thumbs-up", response_builder[0].label
  end

  test "completion item uses prefix filter" do
    code = 'icon("thumbs")'
    node = Prism.parse(code).value.statements.body.first

    response_builder = []
    dispatcher = MockDispatcher.new

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up thumbs-down arrow],
      "/tmp/icons",
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    assert_equal 2, response_builder.size

    labels = response_builder.map(&:label)

    assert_includes labels, "thumbs-up"
    assert_includes labels, "thumbs-down"
    refute_includes labels, "arrow"
  end

  test "completion only triggers on icon method" do
    code = 'something_else("test")'
    node = Prism.parse(code).value.statements.body.first

    assert_equal :something_else, node.name

    response_builder = []
    dispatcher = MockDispatcher.new

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up],
      "/tmp/icons",
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    assert_empty response_builder
  end

  test "completion returns empty for non-matching prefix" do
    code = 'icon("zzz")'
    node = Prism.parse(code).value.statements.body.first

    response_builder = []
    dispatcher = MockDispatcher.new

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up arrow],
      "/tmp/icons",
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    assert_empty response_builder
  end

  test "completion is case-insensitive" do
    code = 'icon("THUMBS")'
    node = Prism.parse(code).value.statements.body.first

    response_builder = []
    dispatcher = MockDispatcher.new

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up thumbs-down arrow],
      "/tmp/icons",
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    assert_equal 2, response_builder.size
    labels = response_builder.map(&:label)
    assert_includes labels, "thumbs-up"
    assert_includes labels, "thumbs-down"
  end

  test "completion supports fuzzy matching" do
    code = 'icon("tbu")'
    node = Prism.parse(code).value.statements.body.first

    response_builder = []
    dispatcher = MockDispatcher.new

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up thumbs-down arrow],
      "/tmp/icons",
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    assert_equal 1, response_builder.size
    assert_equal "thumbs-up", response_builder[0].label
  end

  test "deactivate clears instance variables" do
    addon = RubyLsp::RailsIcons::Addon.new
    addon.instance_variable_set(:@workspace_path, Rails.root.to_s)
    addon.instance_variable_set(:@icons, %w[test-icon])

    addon.deactivate

    assert_nil addon.instance_variable_get(:@workspace_path)
    assert_nil addon.instance_variable_get(:@icons)
  end

  test "completion works with empty icon name" do
    code = 'icon()'
    node = Prism.parse(code).value.statements.body.first

    response_builder = []
    dispatcher = MockDispatcher.new

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up arrow],
      "/tmp/icons",
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    assert_equal 2, response_builder.size
  end

  test "completion shows all icons with empty string" do
    code = 'icon("")'
    node = Prism.parse(code).value.statements.body.first

    response_builder = []
    dispatcher = MockDispatcher.new

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up arrow],
      "/tmp/icons",
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    assert_equal 2, response_builder.size
  end

  test "completion provides library suggestions" do
    code = 'icon("test", library: "tab")'
    node = Prism.parse(code).value.statements.body.first

    response_builder = []
    dispatcher = MockDispatcher.new

    icons_path = File.join(Rails.root.to_s, "app/assets/svg/icons")

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up],
      icons_path,
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    labels = response_builder.map(&:label)
    assert_includes labels, "tabler"
  end

  test "completion provides variant suggestions" do
    code = 'icon("test", variant: "out")'
    node = Prism.parse(code).value.statements.body.first

    response_builder = []
    dispatcher = MockDispatcher.new

    icons_path = File.join(Rails.root.to_s, "app/assets/svg/icons")

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up],
      icons_path,
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    labels = response_builder.map(&:label)
    assert_includes labels, "outline"
  end

  test "completion provides variant suggestions for specified library" do
    code = 'icon("test", library: "heroicons", variant: "mi")'
    node = Prism.parse(code).value.statements.body.first

    response_builder = []
    dispatcher = MockDispatcher.new

    icons_path = File.join(Rails.root.to_s, "app/assets/svg/icons")

    RubyLsp::RailsIcons::Completion.new(
      response_builder,
      node,
      %w[thumbs-up],
      icons_path,
      "tabler",
      dispatcher
    )

    dispatcher.fire(:on_call_node_enter, node)

    labels = response_builder.map(&:label)
    assert_includes labels, "mini"

    refute_includes labels, "outline"
  end
end

class MockDispatcher
  def initialize
    @listeners = {}
  end

  def register(listener, event)
    @listeners[event] = listener
  end

  def fire(event, node)
    listener = @listeners[event]

    return unless listener

    listener.send(event, node)
  end
end

class MockGlobalState
  def workspace_path = Rails.root.to_s
end
