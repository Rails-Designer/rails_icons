# frozen_string_literal: true

module RailsIcons
  class BaseGenerator < Rails::Generators::Base
    def initialize(*arguments)
      super(*arguments)

      validate!
    end

    private

    def validate!
      raise RailsIcons::LibraryNotFound.new("") if options.libraries.empty?
      raise RailsIcons::LibraryNotFound.new(invalid_libraries.join(", ")) if invalid_libraries.any?
    end

    def invalid_libraries = options.libraries.map(&:to_sym).map(&:downcase).reject { RailsIcons.libraries.key?(_1) }
  end
end
