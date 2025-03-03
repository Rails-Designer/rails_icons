# Rails Icons

Add any icon library to a Rails app. Rails Icons has first-party support for a [handful of libraries](#first-party-libraries). It is library agnostic so it can be used with any icon library using the same interface.

```erb
# Using the default icon library
<%= icon "check", class: "text-gray-500" %>

# Using any custom library
<%= icon "apple", library: "simple_icons", class: "text-black" %>
```

The icons are sourced directly from their respective GitHub repositories, ensuring Rails Icons remain lightweight.


**Sponsored By [Rails Designer](https://railsdesigner.com/)**

<a href="https://railsdesigner.com/" target="_blank">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Rails-Designer/rails_icons/HEAD/.github/logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/Rails-Designer/rails_icons/HEAD/.github/logo-light.svg">
    <img alt="Rails Designer" src="https://raw.githubusercontent.com/Rails-Designer/rails_icons/HEAD/.github/logo-light.svg" width="240" style="max-width: 100%;">
  </picture>
</a>


## Install

Add the gem
```bash
bundle add rails_icons
```

Install, choosing one of the supported libraries
```bash
rails generate rails_icons:install --libraries=LIBRARY_NAME
```

**Example**
```bash
rails generate rails_icons:install --libraries=heroicons

# Or multiple at once
rails generate rails_icons:install --libraries=heroicons lucide
```


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

- [Boxicons](https://railsdesigner.com/rails-icons/boxicons/) (1600+ icons)
- [Feather](https://railsdesigner.com/rails-icons/feather/) (280+ icons)
- [Flags](https://railsdesigner.com/rails-icons/flags/) (540+ icons)
- [Heroicons](https://railsdesigner.com/rails-icons/heroicons/) (300+ icons)
- [Linear](https://railsdesigner.com/rails-icons/linear/) (170+ icons)
- [Lucide](https://railsdesigner.com/rails-icons/lucide/) (1500+ icons)
- [Phosphor](https://railsdesigner.com/rails-icons/phosphor/) (9000+ icons)
- [Radix](https://railsdesigner.com/rails-icons/radix/) (300+ icons)
- [SidekickIcons](https://railsdesigner.com/rails-icons/sidekickicons/) (49 icons, complementing [Heroicons](https://railsdesigner.com/rails-icons/heroicons/))
- [Tabler](https://railsdesigner.com/rails-icons/tabler/) (5700+ icons)
- [Weather](https://railsdesigner.com/rails-icons/weather/) (215+ icons)


## Animated icons

Rails Icons also includes a few animated icons. Great for loading states and so on. These are currently included:

- `faded-spinner`
- `trailing-spinner`
- `fading-dots`
- `bouncing-dots`

Use like this: `icon "faded-spinner", library: "animated"`. The same attributes as the others libraries are available.


## Custom icon library

Need to use an icon from another library?

1. run `rails generate rails_icons:initializer --custom=simple_icons`;
2. add the (SVG) icons to the created directory **app/assets/svg/icons/simple_icons**;

Every custom icon can now be used with the same interface as first-party icon libraries.
```ruby
icon "apple", library: "simple_icons", class: "text-black"
```


## Sync icons

To sync all libraries, run
```bash
rails generate rails_icons:sync
```

To sync only a specific library, run
```bash
rails generate rails_icons:sync --libraries=heroicons

# Or multiple at once:
rails generate rails_icons:sync --libraries=heroicons lucide
```


## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Please make sure to run `be standardrb` before submitting pull requests. Run tests via `rails test`.


## License

Rails Icons is released under the [MIT License](https://opensource.org/licenses/MIT).
