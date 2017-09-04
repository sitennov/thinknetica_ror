require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module Thinknetica
  class Application < Rails::Application
    config.app_generators.scaffold_controller :responders_controller

    config.load_defaults 5.1

    config.action_cable.disable_request_forgery_protection = false

    config.active_job.queue_adapter = :sidekiq

    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    config.generators do |g|
      g.test_framework :rspec,
                        fixtures: true,
                        view_spec: false,
                        helper_specs: false,
                        routing_specs: false,
                        request_specs: false,
                        controller_spec: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
    # config.i18n.default_locale = :ru
  end
end
