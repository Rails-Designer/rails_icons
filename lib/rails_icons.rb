# frozen_string_literal: true

require "icons"

require_relative "rails_icons/version"
require_relative "rails_icons/engine"

module RailsIcons
  class << self
    def configure(&block) = Icons.configure(&block)

    def configuration = Icons.configuration
    alias_method :config, :configuration

    def libraries = Icons.libraries
  end
end
