require File.expand_path("../boot", __FILE__)

require "rails"

require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)
require "rails_icons"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    # For compatibility with applications that use this config
    config.action_controller.include_all_helpers = false
  end
end
