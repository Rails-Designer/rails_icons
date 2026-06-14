# frozen_string_literal: true

require "icons"

require_relative "rails_icons/version"
require_relative "rails_icons/engine"

module RailsIcons
  class << self
    # @yield [config] Yields a configuration object
    # @yieldparam config [Icons::Configuration]
    #
    def configure(&block) = Icons.configure(&block)

    # @return [Icons::Configuration]
    #
    def configuration = Icons.configuration
    alias_method :config, :configuration

    # @return [Hash{Symbol => Icons::Library}] The registered icon libraries
    #
    def libraries = Icons.libraries
  end
end
