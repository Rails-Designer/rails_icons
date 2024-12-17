module RailsIcons
  module Libraries
    module_function

    def all
      {
        feather: RailsIcons::Configuration::Feather,
        heroicons: RailsIcons::Configuration::Heroicons,
        lucide: RailsIcons::Configuration::Lucide,
        phosphor: RailsIcons::Configuration::Phosphor,
        tabler: RailsIcons::Configuration::Tabler
      }
    end
  end
end
