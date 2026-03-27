# Rails Icons

Add any icon library to a Rails app. Rails Icons has first-party support for a [handful of libraries](#first-party-libraries). It is library agnostic so it can be used with any icon library using the same interface. Rails Icons is a Rails gem for the [Icons Ruby gem](https://github.com/Rails-Designer/icons).

![Rails Icons - A collection of icons from popular libraries like Feather, Lucide, and Heroicons arranged in a grid pattern around the title text](https://raw.githubusercontent.com/Rails-Designer/rails_icons/HEAD/.github/cover.jpg)

```erb
# Using the default icon library
icon "check", class: "text-gray-500"

# Using any custom library
icon "apple", library: "simple_icons", class: "text-black"
```

The icons are sourced directly from their respective GitHub repositories via the [Icons](https://github.com/Rails-Designer/icons) gem, ensuring Rails Icons remain lightweight.


**Sponsored By [Rails Designer](https://railsdesigner.com/)**

<a href="https://railsdesigner.com/" target="_blank">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Rails-Designer/rails_icons/HEAD/.github/logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/Rails-Designer/rails_icons/HEAD/.github/logo-light.svg">
    <img alt="Rails Designer" src="https://raw.githubusercontent.com/Rails-Designer/rails_icons/HEAD/.github/logo-light.svg" width="240" style="max-width: 100%;">
  </picture>
</a>


## Install

Add the gem:
```bash
bundle add rails_icons
```

Install, choosing one of the supported libraries:
```bash
rails generate rails_icons:install --library=LIBRARY_NAME
```

**Example**
```bash
rails generate rails_icons:install --library=heroicons

# Or multiple at once
rails generate rails_icons:install --libraries=heroicons lucide
```

The generator also mounts an icon preview at `/rails_icons` where you can browse and search all your available icons. This route is open by default, so restrict it in production if needed.


## Usage

```ruby
# Uses the default library and variant defined in config/initializer/rails_icons.rb
icon "check"

# Use another variant
icon "check", variant: "solid"

# Set library explicitly
icon "check", library: "heroicons"

# Add CSS
icon "check", class: "text-green-500"

# Add CSS with class_names
icon "check", class: ["size-4", "bg-red-500": !verified?, "bg-green-500": verified?]
# ↳ Article: https://railsdesigner.com/conditional-css-classes-in-rails/
# ↳ Documentation: https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/TagHelper.html#method-i-token_list

# Add data attributes
icon "check", data: { controller: "swap" }

# Set the stroke-width
icon "check", stroke_width: 2
```


## First-party libraries

- [Boxicons](https://railsdesigner.com/open-source/rails-icons/boxicons/) (1600+ icons)
- [Feather](https://railsdesigner.com/open-source/rails-icons/feather/) (280+ icons)
- [Flags](https://railsdesigner.com/open-source/rails-icons/flags/) (250+ icons)
- [Heroicons](https://railsdesigner.com/open-source/rails-icons/heroicons/) (280+ icons)
- [Lucide](https://railsdesigner.com/open-source/rails-icons/lucide/) (1000+ icons)
- [Phosphor](https://railsdesigner.com/open-source/rails-icons/phosphor/) (1200+ icons)
- [Remix](https://railsdesigner.com/open-source/rails-icons/remix/) (2200+ icons)
- [Tabler](https://railsdesigner.com/open-source/rails-icons/tabler/) (4200+ icons)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Rails-Designer/rails_icons. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Rails-Designer/rails_icons/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).