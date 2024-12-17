module RailsIcons
  extend self

  def libraries
    {
      feather: RailsIcons::Configuration::Feather,
      heroicons: RailsIcons::Configuration::Heroicons,
      lucide: RailsIcons::Configuration::Lucide,
      phosphor: RailsIcons::Configuration::Phosphor,
      tabler: RailsIcons::Configuration::Tabler
    }
  end
end
