require_relative "configuration/animated"
require_relative "configuration/boxicons"
require_relative "configuration/feather"
require_relative "configuration/heroicons"
require_relative "configuration/lucide"
require_relative "configuration/phosphor"
require_relative "configuration/tabler"

module RailsIcons
  extend self

  def libraries
    {
      boxicons: RailsIcons::Configuration::Boxicons,
      feather: RailsIcons::Configuration::Feather,
      heroicons: RailsIcons::Configuration::Heroicons,
      lucide: RailsIcons::Configuration::Lucide,
      phosphor: RailsIcons::Configuration::Phosphor,
      tabler: RailsIcons::Configuration::Tabler
    }
  end
end
