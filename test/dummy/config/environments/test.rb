Rails.application.configure do
  config.cache_classes = true

  config.eager_load = false

  config.serve_static_files = true
  config.static_cache_control = "public, max-age=3600"
  config.assets.digest = true

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection = false

  config.active_support.test_order = :random

  config.active_support.deprecation = :stderr
end
