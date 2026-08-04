# frozen_string_literal: true

require "active_support/core_ext/numeric/time"
require "icons"

require_relative "rails_icons/version"
require_relative "rails_icons/engine"

module RailsIcons
  class << self
    attr_accessor :sprite_cache_expires_in

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

  self.sprite_cache_expires_in = 1.hour
end
