require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

Bundler.require(:default, Rails.env)

module Loggia
  class Application < Rails::Application

    # Add lib to autoloaded files
    config.autoload_paths += %W(
      #{config.root}/lib
      #{config.root}/app/services
      #{config.root}/app/models/queries
    )
  end
end
