# frozen_string_literal: true

module RailsIcons
  class Preview
    include Tags

    def libraries
      host_libraries = Dir.glob("#{icons_path}/*").select { |path| File.directory?(path) }.map { |path| File.basename(path) }
      host_libraries << "animated" if animated_icons.any?
      host_libraries.uniq.sort_by { |lib| (lib == default_library) ? "0" : lib }
    end

    def variants(library)
      return [] if library.to_sym == :animated

      path = "#{icons_path}/#{library}"
      entries = Dir.glob("#{path}/*")
      has_direct_svgs = entries.any? { |entry| entry.end_with?(".svg") }

      return [] if has_direct_svgs

      entries.select { |entry| File.directory?(entry) }.map { |entry| File.basename(entry) }
    end

    def icon_names(library, variant = nil)
      if library.to_sym == :animated
        animated_icons.map { |path| File.basename(path, ".svg") }
      else
        path = variant ? "#{icons_path}/#{library}/#{variant}" : "#{icons_path}/#{library}"

        Dir.glob("#{path}/*.svg").map { |file| File.basename(file, ".svg") }
      end
    end

    private

    def animated_icons
      @animated_icons ||= Dir.glob("#{animated_gem_path}/*.svg")
    end

    def animated_gem_path
      Gem::Specification.find_by_name("icons").gem_dir + "/lib/icons/assets/animated"
    end

    def icons_path
      RailsIcons.configuration.icons_path
    end

    def default_library
      RailsIcons.configuration.default_library
    end
  end
end
