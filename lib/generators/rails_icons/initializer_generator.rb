module RailsIcons
  class InitializerGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def copy_initializer
      copy_file "initializer.rb", "config/initializers/rails_icons.rb"
    end
  end
end
