# frozen_string_literal: true

module RailsIcons
  class Sprite
    Reference = Data.define(:name, :library, :variant) do
      def id = [library, variant, name].join("_")

      def file_path
        Icons::Icon::FilePath.new(
          name: name.to_s,
          library: library.to_s,
          variant: variant.to_s
        ).call
      end

      def exists?
        File.exist?(file_path)
      rescue Icons::IconNotFound
        false
      end
    end
  end
end
