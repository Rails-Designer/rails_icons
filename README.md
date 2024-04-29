# Rails Icons

Embed any library's icon in your Rails app. There are many icon gems for Rails already, but none are library-agnostic. This means you need to pull in other gems or add your logic to display that one specific icon.

Supported libraries:

- [Heroicons](https://heroicons.com/)
- [Lucide Icons](https://lucide.dev/)
- [Animated](#animated-svg)
- [more coming…](https://github.com/rails-designer/rails_icons/issues)


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


## Usage

```ruby
# The default library is Heroicons, with "outline" as the default set
icon "check"

# Use another set (options are: outline, solid, mini, micro)
icon "check", set: "solid"

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
  config.default_library = "heroicons" # https://heroicons.com/
  config.default_set = "outline" # other sets for Heroicons are: solid, mini, micro

  config.libraries.heroicons.solid.default.css = "w-6 h-6"
  config.libraries.heroicons.solid.default.data = {}

  config.libraries.heroicons.outline.default.css = "w-6 h-6"
  config.libraries.heroicons.outline.default.stroke_width = "1.5"
  config.libraries.heroicons.outline.default.data = {}

  config.libraries.heroicons.mini.default.css = "w-5 h-5"
  config.libraries.heroicons.mini.default.data = {}

  config.libraries.heroicons.micro.default.css = "w-4 h-4"
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


## Animated SVG

Rails Icons includes a selection of custom, animated SVG icons, ideal for [loading states](https://railsdesigner.com/components/empty-states/#loading-state) or [disabled buttons](https://railsdesigner.com/components/buttons/#secondary-button-with-busy-spinner).

Available:

- `tailing-spinner`
- `fading-dots`
- `bouncing-dots`


## License

Rails Icons is released under the [MIT License](https://opensource.org/licenses/MIT).
