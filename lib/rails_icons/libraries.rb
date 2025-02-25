require_relative "configuration/animated"
require_relative "configuration/boxicons"
require_relative "configuration/feather"
require_relative "configuration/flags"
require_relative "configuration/heroicons"
require_relative "configuration/sidekickicons"
require_relative "configuration/lucide"
require_relative "configuration/phosphor"
require_relative "configuration/radix"
require_relative "configuration/tabler"

module RailsIcons
  extend self

  def libraries
    {
      boxicons: RailsIcons::Configuration::Boxicons,
      feather: RailsIcons::Configuration::Feather,
      flags: RailsIcons::Configuration::Flags,
      heroicons: RailsIcons::Configuration::Heroicons,
      sidekickicons: RailsIcons::Configuration::Sidekickicons,
      lucide: RailsIcons::Configuration::Lucide,
      phosphor: RailsIcons::Configuration::Phosphor,
      radix: RailsIcons::Configuration::Radix,
      tabler: RailsIcons::Configuration::Tabler
    }
  end
end
