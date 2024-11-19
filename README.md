# Rails Icons

Embed any library's icon in your Rails app. There are many icon gems for Rails already, but none are library-agnostic. This means you need to pull in other gems or add your logic to display that one specific icon.

The first-party supported icons are stored in a seperate repo: [rails_icons_vault](https://github.com/Rails-Designer/rails_icons_vault). This allows you to pull in only the icon libraries you need, keeping the rails_icons gem lean and lightweight.


## Sponsored By [Rails Designer](https://railsdesigner.com/)

<a href="https://railsdesigner.com/" target="_blank">
  <img src="https://raw.githubusercontent.com/Rails-Designer/rails_icons/main/docs/rails_designer_icon.jpg" alt="Rails Designer logo"  width="300" />
</a>


## Install

Add this line to your Gemfile:

```ruby
gem "rails_icons"
```

And run:

```bash
bundle
```

Sync any of the supported icon libraries from the
[rails_icons_vault](https://github.com/Rails-Designer/rails_icons_vault):

```bash
rails generate rails_icons:sync heroicons
```


## Supported Libraries

- [Heroicons](https://github.com/tailwindlabs/heroicons)
- [Lucide](https://github.com/lucide-icons/lucide)
- [Tabler](https://github.com/tabler/tabler-icons)


## Usage

```ruby
# The default library is Heroicons, with "outline" as the default set
icon "check"

# Use another set (options are: outline, solid, mini, micro)
icon "check", variant: "solid"

# Add CSS to the icon
icon "check", class: "text-green-500"

# Add data attributes
icon "check", data: { controller: "swap" }

# Tweak the stroke-width
icon "check", stroke_width: 2
```


## Initializer

```ruby
RailsIcons.configure do |config|
  # Set the default set for the library
  config.default_library = "heroicons"
  config.default_variant = "outline"

  config.libraries.heroicons.solid.default.css = "size-6"
  config.libraries.heroicons.solid.default.data = {}

  config.libraries.heroicons.outline.default.css = "size-6"
  config.libraries.heroicons.outline.default.stroke_width = "1.5"
  config.libraries.heroicons.outline.default.data = {}

  config.libraries.heroicons.mini.default.css = "size-5"
  config.libraries.heroicons.mini.default.data = {}

  config.libraries.heroicons.micro.default.css = "size-4"
  config.libraries.heroicons.micro.default.data = {}
end
```

Or run `rails generate rails_icons:initializer`.


## Add a custom icon library

```ruby
RailsIcons.configure do |config|
  # …
  config.libraries.merge!(
    {
      custom: {
        simple_icons: {
          solid: {
            path: "app/assets/svg/simple_icons/solid", # optional: the default lookup path is: `app/assets/svg/#{library_name}/#{set}`
            default: {
              css: "w-6 h-6"
            }
          }
        }
      }
    }
  )
  # …
end
```

You can now use any svg-icon in the `app/assets/svg/simple_icons/solid` folder as a first-party icon:

```ruby
icon "reddit", library: "simple_icons", set: "solid"
```


## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Please make sure to run `be standardrb` before submitting pull requests. Run tests via `rails test`.


## License

Rails Icons is released under the [MIT License](https://opensource.org/licenses/MIT).
