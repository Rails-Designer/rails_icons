# frozen_string_literal: true

require_relative "rails_icons/version"
require_relative "rails_icons/engine"
require_relative "rails_icons/configuration"
require_relative "rails_icons/errors"
require_relative "rails_icons/railtie"
require_relative "rails_icons/icon"

module RailsIcons
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.icons_directory
    File.join("lib", "assets", "rails_icons")
  end
end
