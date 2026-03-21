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
        @icons = nil
        @workspace_path = nil
      end

      def name = "Rails Icons"

      def version = ::RailsIcons::VERSION

      def create_completion_listener(response_builder, node_context, dispatcher, uri)
        node = node_context.node

        if node.is_a?(Prism::CallNode) && node.name == :icon
          Completion.new(response_builder, node, @icons, icons_path, default_library, dispatcher)
        elsif node.is_a?(Prism::StringNode)
          icon_call = find_icon_call_in_source(uri, node)

          return unless icon_call

          Completion.new(response_builder, icon_call, @icons, icons_path, default_library, dispatcher)
        end
      end

      private

      def configuration
        ::RailsIcons.configuration
      rescue NameError, LoadError
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

      def find_icon_call_in_source(uri, target_node)
        return nil unless File.exist?(uri.path)

        source = File.read(uri.path)
        ast = Prism.parse(source)

        find_icon_in_ast(ast.value, target_node)
      rescue
        nil
      end

      def find_icon_in_ast(node, target_node, nesting_depth = 0)
        return nil if node.nil? || nesting_depth > 10

        if node.is_a?(Prism::CallNode) && node.name == :icon
          return node if node_contains_target?(node, target_node)
        end

        child_nodes = collect_child_nodes(node)
        child_nodes.each do |child|
          result = find_icon_in_ast(child, target_node, nesting_depth + 1)

          return result if result
        end

        nil
      end

      def collect_child_nodes(node)
        children = []

        if node.respond_to?(:arguments) && node.arguments
          children.concat(node.arguments.arguments)
        end

        if node.respond_to?(:elements)
          children.concat(node.elements)
        end

        children
      end

      def node_contains_target?(parent_node, target_node)
        return false if target_node.nil?

        parent_location = parent_node.location
        return false unless parent_location

        target_location = target_node.location
        return false unless target_location

        parent_start = parent_location.start_offset || 0
        parent_end = parent_location.end_offset || parent_start
        target_start = target_location.start_offset || 0
        target_end = target_location.end_offset || target_start

        target_start >= parent_start && target_end <= parent_end
      rescue
        false
      end
    end

    class Completion
      include ::RubyLsp::Requests::Support::Common

      def initialize(response_builder, node, icons, icons_path, default_library, dispatcher)
        @response_builder = response_builder
        @node = node
        @icons = icons
        @icons_path = icons_path
        @default_library = default_library

        dispatcher.register(self, :on_call_node_enter)
        dispatcher.register(self, :on_string_node_enter)
      end

      def on_call_node_enter(node)
        return unless node.name == :icon

        if completing_keyword_argument?(node)
          complete_keyword_argument(node)
        else
          complete_icon_name(node)
        end
      end

      def on_string_node_enter(node)
        return unless inside_icon_call?(node)

        if keyword_argument_value?(node)
          complete_keyword_argument_value(node)
        else
          complete_icon_name_from_string(node)
        end
      end

      private

      def inside_icon_call?(node)
        @node.is_a?(Prism::CallNode) && @node.name == :icon
      end

      def keyword_argument_value?(node)
        return false unless @node.is_a?(Prism::CallNode)
        return false unless @node.arguments

        keyword_hash = @node.arguments.arguments.find { |argument| argument.is_a?(Prism::KeywordHashNode) }
        return false unless keyword_hash

        keyword_hash.elements.any? do |association|
          association.is_a?(Prism::AssocNode) && association.value == node
        end
      end

      def completing_keyword_argument?(node)
        arguments = node.arguments&.arguments
        return false if arguments.nil? || arguments.empty?

        keyword_hash = arguments.find { |argument| argument.is_a?(Prism::KeywordHashNode) }
        return false unless keyword_hash

        keyword_hash.elements.any? do |association|
          next false unless association.is_a?(Prism::AssocNode)

          key_node = association.key
          key_node.is_a?(Prism::SymbolNode) && %w[library variant].include?(key_node.value.to_s)
        end
      end

      def complete_keyword_argument(node)
        complete_icon_name(node)

        arguments = node.arguments.arguments
        keyword_hash = arguments.find { |argument| argument.is_a?(Prism::KeywordHashNode) }
        return unless keyword_hash

        keyword_hash.elements.each do |association|
          next unless association.is_a?(Prism::AssocNode)

          key_node = association.key
          next unless key_node.is_a?(Prism::SymbolNode)

          key_name = key_node.value.to_s
          value_node = association.value

          next unless value_node.is_a?(Prism::StringNode)

          if key_name == "library"
            complete_library_values(value_node)
          elsif key_name == "variant"
            complete_variant_values_for_call(value_node, node)
          end
        end
      end

      def complete_keyword_argument_value(node)
        return unless @node.is_a?(Prism::CallNode)

        keyword_hash = @node.arguments&.arguments&.find { |argument| argument.is_a?(Prism::KeywordHashNode) }
        return unless keyword_hash

        complete_icon_name(@node)

        keyword_hash.elements.each do |association|
          next unless association.is_a?(Prism::AssocNode)
          next unless association.value == node

          key_node = association.key
          next unless key_node.is_a?(Prism::SymbolNode)

          key_name = key_node.value.to_s

          if key_name == "library"
            complete_library_values(node)
          elsif key_name == "variant"
            complete_variant_values(node, @node)
          end
        end
      end

      def complete_library_values(value_node)
        return unless File.directory?(@icons_path)

        libraries = Dir.entries(@icons_path).select do |entry|
          next if entry.start_with?(".")

          File.directory?(File.join(@icons_path, entry))
        end

        prefix = value_node.content.to_s.downcase

        libraries.each do |library|
          next unless matches_pattern?(library, prefix)

          @response_builder << Interface::CompletionItem.new(
            label: library,
            kind: Constant::CompletionItemKind::VALUE,
            text_edit: Interface::TextEdit.new(
              range: value_range(value_node),
              new_text: library
            )
          )
        end
      end

      def complete_variant_values(value_node, node)
        library = extract_library_from_node(node) || @default_library
        return unless library

        library_dir = File.join(@icons_path, library)
        return unless File.directory?(library_dir)

        variants = Dir.entries(library_dir).select do |entry|
          next if entry.start_with?(".")

          File.directory?(File.join(library_dir, entry))
        end

        prefix = value_node.content.to_s.downcase

        variants.each do |variant|
          next unless matches_pattern?(variant, prefix)

          @response_builder << Interface::CompletionItem.new(
            label: variant,
            kind: Constant::CompletionItemKind::VALUE,
            text_edit: Interface::TextEdit.new(
              range: value_range(value_node),
              new_text: variant
            )
          )
        end
      end

      def complete_variant_values_for_call(value_node, node)
        library = extract_library_from_node(node) || @default_library
        return unless library

        library_dir = File.join(@icons_path, library)
        return unless File.directory?(library_dir)

        variants = Dir.entries(library_dir).select do |entry|
          next if entry.start_with?(".")

          File.directory?(File.join(library_dir, entry))
        end

        prefix = value_node.content.to_s.downcase

        variants.each do |variant|
          next unless matches_pattern?(variant, prefix)

          @response_builder << Interface::CompletionItem.new(
            label: variant,
            kind: Constant::CompletionItemKind::VALUE,
            text_edit: Interface::TextEdit.new(
              range: value_range(value_node),
              new_text: variant
            )
          )
        end
      end

      def extract_library_from_node(node)
        return nil unless node.arguments

        keyword_hash = node.arguments.arguments.find { |argument| argument.is_a?(Prism::KeywordHashNode) }
        return nil unless keyword_hash

        keyword_hash.elements.each do |association|
          next unless association.is_a?(Prism::AssocNode)

          key_node = association.key
          next unless key_node.is_a?(Prism::SymbolNode)

          if key_node.value.to_s == "library"
            value_node = association.value

            return value_node.content.to_s if value_node.is_a?(Prism::StringNode)
          end
        end

        nil
      end

      def complete_icon_name(node)
        prefix = extract_prefix(node).to_s.downcase

        @icons.each do |icon|
          next unless matches_pattern?(icon, prefix)

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

      def complete_icon_name_from_string(node)
        prefix = node.content.to_s.downcase

        @icons.each do |icon|
          next unless matches_pattern?(icon, prefix)

          @response_builder << Interface::CompletionItem.new(
            label: icon,
            kind: Constant::CompletionItemKind::VALUE,
            text_edit: Interface::TextEdit.new(
              range: string_range(node),
              new_text: icon
            )
          )
        end
      end

      def matches_pattern?(text, pattern)
        return true if pattern.empty?

        text = text.to_s.downcase
        pattern = pattern.to_s.downcase

        return true if text.start_with?(pattern)

        fuzzy_match?(text, pattern)
      end

      def fuzzy_match?(text, pattern)
        pattern_chars = pattern.chars
        text_chars = text.chars
        pattern_index = 0

        text_chars.each do |char|
          if char == pattern_chars[pattern_index]
            pattern_index += 1

            return true if pattern_index >= pattern_chars.length
          end
        end

        false
      end

      def extract_prefix(node)
        arguments = node.arguments
        return "" if arguments.nil?

        first_argument = arguments.arguments&.first
        return "" unless first_argument.is_a?(Prism::StringNode)

        first_argument.content.to_s
      end

      def first_argument_range(node)
        arguments = node.arguments
        first_argument = arguments&.arguments&.first

        if arguments.nil?
          return insertion_range_after_opening_paren(node)
        end

        unless first_argument.is_a?(Prism::StringNode)
          return zero_width_range(arguments.location)
        end

        content_location = first_argument.content_loc

        if content_location.start_column == content_location.end_column
          return Interface::Range.new(
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

      def string_range(node)
        content_location = node.content_loc

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

      def value_range(value_node)
        content_location = value_node.content_loc

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

      def insertion_range_after_opening_paren(node)
        message_location = node.message_loc

        Interface::Range.new(
          start: Interface::Position.new(
            line: message_location.end_line - 1,
            character: message_location.end_column + 1
          ),

          end: Interface::Position.new(
            line: message_location.end_line - 1,
            character: message_location.end_column + 1
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
