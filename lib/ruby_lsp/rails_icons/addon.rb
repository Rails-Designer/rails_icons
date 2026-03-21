# frozen_string_literal: true

require "ruby_lsp/addon"

require_relative "../../rails_icons/version"

module RubyLsp
  module RailsIcons
    class Addon < ::RubyLsp::Addon
      def activate(global_state, message_queue)
        @workspace_path = global_state.workspace_path
        @icons = index_icons
      end

      def deactivate
      end

      def name = "Rails Icons"

      def version = ::RailsIcons::VERSION

      def create_completion_listener(response_builder, node_context, dispatcher, uri)
        node = node_context.node

        return unless node.is_a?(Prism::CallNode) && node.name == :icon

        Completion.new(response_builder, node, @icons, dispatcher)
      end

      private

      def configuration
        ::RailsIcons.configuration
      rescue
        nil
      end

      def default_library
        configuration&.default_library&.to_s
      end

      def icons_path
        File.join(@workspace_path, configuration&.icons_path || "app/assets/svg/icons")
      end

      def library_path
        default_library ? File.join(icons_path, default_library) : icons_path
      end

      def index_icons
        Dir.glob("#{library_path}/**/*.svg").map { |path| File.basename(path, ".svg") }.uniq.sort
      end
    end

    class Completion
      include ::RubyLsp::Requests::Support::Common

      def initialize(response_builder, node, icons, dispatcher)
        @response_builder = response_builder
        @node = node
        @icons = icons

        dispatcher.register(self, :on_call_node_enter)
      end

      def on_call_node_enter(node)
        return unless node.name == :icon

        prefix = extract_prefix(node)

        @icons.each do |icon|
          next unless icon.start_with?(prefix)

          @response_builder << Interface::CompletionItem.new(
            label: icon,
            kind: Constant::CompletionItemKind::VALUE,
            text_edit: Interface::TextEdit.new(
              range: first_argument_range(node),
              new_text: icon
            )
          )
        end
      end

      private

      def extract_prefix(node)
        first_argument = node.arguments&.arguments&.first

        return "" unless first_argument.is_a?(Prism::StringNode)

        first_argument.content
      end

      def first_argument_range(node)
        first_argument = node.arguments&.arguments&.first

        return zero_width_range(node.location) unless first_argument.is_a?(Prism::StringNode)

        content_location = first_argument.content_loc

        Interface::Range.new(
          start: Interface::Position.new(
            line: content_location.start_line - 1,
            character: content_location.start_column
          ),

          end: Interface::Position.new(
            line: content_location.end_line - 1,
            character: content_location.end_column
          )
        )
      end

      def zero_width_range(location)
        Interface::Range.new(
          start: Interface::Position.new(
            line: location.end_line - 1,
            character: location.end_column
          ),

          end: Interface::Position.new(
            line: location.end_line - 1,
            character: location.end_column
          )
        )
      end
    end
  end
end
