require_relative "configuration/animated"
require_relative "configuration/boxicons"
require_relative "configuration/feather"
require_relative "configuration/flags"
require_relative "configuration/heroicons"
require_relative "configuration/linear"
require_relative "configuration/lucide"
require_relative "configuration/phosphor"
require_relative "configuration/radix"
require_relative "configuration/sidekickicons"
require_relative "configuration/tabler"
require_relative "configuration/weather"

module RailsIcons
  extend self

  def libraries
    {
      boxicons: RailsIcons::Configuration::Boxicons,
      feather: RailsIcons::Configuration::Feather,
      flags: RailsIcons::Configuration::Flags,
      heroicons: RailsIcons::Configuration::Heroicons,
      linear: RailsIcons::Configuration::Linear,
      lucide: RailsIcons::Configuration::Lucide,
      phosphor: RailsIcons::Configuration::Phosphor,
      radix: RailsIcons::Configuration::Radix,
      sidekickicons: RailsIcons::Configuration::Sidekickicons,
      tabler: RailsIcons::Configuration::Tabler
      weather: RailsIcons::Configuration::Weather
    }
  end
end
