module RailsIcons
  module Libraries
    module_function

    def all
      {
        feather: {
          name: "feather",
          url: "https://github.com/feathericons/feather.git",
          variants: {
            ".": "icons" # Feather has no variants, store in the top directory
          }
        },

        heroicons: {
          name: "heroicons",
          url: "https://github.com/tailwindlabs/heroicons.git",
          variants: {
            outline: "optimized/24/outline",
            solid: "optimized/24/solid",
            mini: "optimized/20/solid",
            micro: "optimized/16/solid"
          }
        },

        lucide: {
          name: "lucide",
          url: "https://github.com/lucide-icons/lucide.git",
          variants: {
            outline: "icons"
          }
        },

        phosphor: {
          name: "phosphor",
          url: "https://github.com/phosphor-icons/core.git",
          variants: {
            bold: "raw/bold",
            duotone: "raw/duotone",
            fill: "raw/fill",
            light: "raw/light",
            regular: "raw/regular",
            thin: "raw/thin"
          }
        },

        tabler: {
          name: "tabler",
          url: "https://github.com/tabler/tabler-icons.git",
          variants: {
            filled: "icons/filled",
            outline: "icons/outline"
          }
        }
      }
    end
  end
end
