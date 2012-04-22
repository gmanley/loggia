require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups(assets: %w(development test))) if defined?(Bundler)

module Soshigal
  class Application < Rails::Application
    # Add sidekiq workers to autoloaded files
    config.autoload_paths += %W(#{config.root}/app/workers)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.generators do |g|
      g.orm                 :mongoid
      g.test_framework      :rspec, fixture: true
      g.fixture_replacement :fabrication
    end
  end
end
