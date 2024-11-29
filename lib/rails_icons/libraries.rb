module RailsIcons
  module Libraries
    module_function

    def all
      {
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

        tabler: {
          name: "tabler",
          url: "https://github.com/tabler/tabler-icons.git",
          variants: {
            filled: "icons/filled",
            outline: "icons/outline"
          }
        },

        lucide: {
          name: "lucide",
          url: "https://github.com/lucide-icons/lucide.git",
          variants: {
            outline: "icons"
          }
        }
      }
    end
  end
end
