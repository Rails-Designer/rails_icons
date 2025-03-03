# frozen_string_literal: true

module RailsIcons
  class IconNotFound < StandardError
    def initialize(icon_name)
      super("The icon `#{icon_name}` is not available. Please check the icon name and try again.")
    end
  end

  class LibraryNotFound < StandardError
    def initialize(library_name)
      if library_name.empty?
        super("No libraries were specified. Please choose from: #{RailsIcons.libraries.keys.to_sentence(last_word_connector: " or ")}")
      else
        super("The library `#{library_name}` is not available. Please check the library name and try again.")
      end
    end
  end
end
