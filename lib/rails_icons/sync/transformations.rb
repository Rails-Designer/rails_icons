module RailsIcons
  module Sync
    class Transformations < Rails::Generators::Base
      def self.transform(filename, rules = {})
        basename = File.basename(filename, File.extname(filename))

        transformed = rules.reduce(basename) do |fn, (type, value)|
          TRANSFORMERS.fetch(type).call(fn, value)
        end

        [transformed, File.extname(filename)].join
      end

      private

      TRANSFORMERS = {
        delete_prefix: ->(filename, prefixes) {
          Array(prefixes).reduce(filename) { _1.delete_prefix(_2) }
        },

        delete_suffix: ->(filename, suffixes) {
          Array(suffixes).reduce(filename) { _1.delete_suffix(_2) }
        }
      }
    end
  end
end
