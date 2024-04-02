module RailsIcons
  class Icon
    class Attributes
      def initialize(default_attributes: {}, args: {})
        @merged_attributes = default_attributes.merge(args)
      end

      def attach(to:)
        @merged_attributes.each do |key, value|
          if value.is_a?(Hash)
            hash_attributes(key, value, to)
          else
            string_attributes(key, value, to)
          end
        end
      end

      private

      def hash_attributes(key, value, to)
        value.each do |nested_key, nested_value|
          nested_attribute_name = format_attribute_name("#{key}-#{nested_key}")

          to[nested_attribute_name] = nested_value
        end
      end

      def string_attributes(key, value, to)
        normalized_key = format_attribute_name(key.to_s)

        to[normalized_key] = value
      end

      def format_attribute_name(name)
        name.tr("_", "-")
      end
    end
  end
end
