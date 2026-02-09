# frozen_string_literal: true

module RailsIcons
  class BaseGenerator < Rails::Generators::Base
    hide!

    def initialize(*arguments)
      super

      validate! if validatable?
    end

    private

    def validate!
      return if custom_library?

      raise Icons::LibraryNotFound.new("") if libraries.empty?
      raise Icons::LibraryNotFound.new(invalid_libraries.join(", ")) if invalid_libraries.any?
    end

    def validatable? = false

    def libraries
      [*options.libraries, options.library].compact_blank
    end

    def invalid_libraries
      libraries.map(&:to_sym).map(&:downcase).reject { |library| RailsIcons.libraries.key?(library) }
    end

    def custom_library?
      options.custom.present?
    end

    # Uses `gsub_file` as a read-only operation to check file content. This
    # approach is preferred over `File.read` because `gsub_file` is properly stubbed
    # in generator tests, while `File.read` would fail in the test environment.
    #
    def file_contains?(path, content)
      return false unless File.exist?(path)

      result = false

      gsub_file(path, /.*/) do |file_content|
        result = file_content.include?(content)

        file_content
      end

      result
    rescue Thor::Error
      false
    end
  end
end
