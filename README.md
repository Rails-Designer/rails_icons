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


## Sprites

Rails Icons supports SVG sprites for improved performance. Instead of inlining each icon's full SVG, sprite icons reference a shared set of `<symbol>` definitions via `<use href="…">`.

### Configuration

```ruby
# config/initializers/rails_icons.rb
RailsIcons.configure do |config|
  config.default_library = "heroicons"
  config.default_variant = "outline"

  # Where `sprite_icon` references symbols. Defaults to the gem-served
  # endpoint below. Set to nil to use inline mode (`<%= icons_sprite %>` in layout).
  config.default_sprite_location = "/rails_icons/sprite.svg"

  # Set to true to validate that referenced icons exist on disk
  config.validate_sprite_icons = false

  # Define which icons to include in the sprite
  config.sprite = {
    heroicons: {
      outline: %w[check chevron-down menu search x],
      mini: %w[check chevron-down]
    }
  }
end
```


### External sprite (default)

Rails Icons serves the sprite at `/rails_icons/sprite.svg` out of the box — no controller, route or MIME type setup needed. The endpoint sits at the host app level, so it stays reachable even when the preview engine is mounted behind authentication.
```erb
<%= sprite_icon "check" %>
<%# renders: <svg><use href="/rails_icons/sprite.svg#heroicons_outline_check"></use></svg> %>
```

Point at a precompiled file or a CDN by changing the location:
```ruby
config.default_sprite_location = "https://cdn.example.com/sprite_icons.svg"
```

Override per icon:
```erb
<%= sprite_icon "check", sprite_location: "/assets/sprites.svg" %>
```


### Inline sprite

Set the location to `nil` and embed the sprite directly in your layout:
```ruby
config.default_sprite_location = nil
```

```erb
<body>
  <%= icons_sprite %>

  <%= sprite_icon "check" %>
  <%= sprite_icon "search", class: "text-blue-500" %>
  <%= sprite_icon "menu", data: { controller: "nav" } %>
</body>
```

You can also generate a sprite for a specific set of icons:
```erb
<%= icons_sprite(["check", "search"], library: "heroicons", variant: "outline") %>
```


### Helpers

`sprite_icon` accepts the same options as `icon`:
```ruby
sprite_icon "check"
sprite_icon "check", library: "heroicons", variant: "mini"
sprite_icon "check", class: "size-6", data: { controller: "swap" }, stroke_width: 2
sprite_icon "check", sprite_location: "/sprite.svg"
```

`icons_sprite` generates the inline `<svg>` containing `<symbol>` definitions:
```ruby
icons_sprite # all configured icons
icons_sprite ["check", "search"]  # specific icons
icons_sprite ["check", "search"], library: "heroicons", variant: "outline"  # with library/variant
```


## First-party libraries

- [Boxicons](https://railsdesigner.com/open-source/rails-icons/boxicons/) (1600+ icons)
- [Feather](https://railsdesigner.com/open-source/rails-icons/feather/) (280+ icons)
- [Flags](https://railsdesigner.com/open-source/rails-icons/flags/) (540+ icons)
- [Heroicons](https://railsdesigner.com/open-source/rails-icons/heroicons/) (300+ icons)
- [Hugeicons](https://railsdesigner.com/open-source/rails-icons/hugeicons/) (4600+ icons)
- [Linear](https://railsdesigner.com/open-source/rails-icons/linear/) (170+ icons)
- [Lucide](https://railsdesigner.com/open-source/rails-icons/lucide/) (1500+ icons)
- [Phosphor](https://railsdesigner.com/open-source/rails-icons/phosphor/) (9000+ icons)
- [Radix](https://railsdesigner.com/open-source/rails-icons/radix/) (300+ icons)
- [SidekickIcons](https://railsdesigner.com/open-source/rails-icons/sidekickicons/) (49 icons, complementing [Heroicons](https://railsdesigner.com/open-source/rails-icons/heroicons/))
- [Tabler](https://railsdesigner.com/open-source/rails-icons/tabler/) (5700+ icons)
- [Weather](https://railsdesigner.com/open-source/rails-icons/weather/) (215+ icons)


## Animated icons

Rails Icons also includes a few animated icons. Great for loading states and so on. These are currently included:

- `faded-spinner`
- `trailing-spinner`
- `fading-dots`
- `bouncing-dots`

Use like this: `icon "faded-spinner", library: "animated"`. The same attributes as the other libraries are available.


## Custom icon library

Need to use an icon from another library (for example [Simple Icons](https://simpleicons.org/))?

1. run `rails generate rails_icons:initializer --custom=simple_icons`;
2. add the SVG icons to the created directory (*app/assets/svg/icons/simple_icons*);

Every custom icon can now be used with the same interface as first-party icon libraries:
```ruby
icon "apple", library: "simple_icons", class: "text-black"
```


## Sync icons

To sync all libraries, run:
```bash
rails generate rails_icons:sync
```

To sync only a specific library, run:
```bash
rails generate rails_icons:sync --library=heroicons

# Or multiple at once:
rails generate rails_icons:sync --libraries=heroicons lucide
```


## Projects using Rails Icons

- [Rails Designer UI Components](https://railsdesigner.com/components/) — The first professionally-designed UI components library for Ruby on Rails apps
- [Chirp Form](https://chirpform.com/) — Add forms to any site. Display responses anywhere
- [Helptail](https://helptail.com/) — Put your routine tasks on autopilot
- [Seal Static](https://sealstatic.com/) — Host sites for every need


## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Please make sure to run `be standardrb` before submitting pull requests. Run tests via `rails test`.


## License

Rails Icons is released under the [MIT License](https://opensource.org/licenses/MIT).
