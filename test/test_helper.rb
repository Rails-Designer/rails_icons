# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path('dummy/config/environment.rb', __dir__)
require "rails/test_help"
require "rails_icons" # Replace with your gem's name

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
