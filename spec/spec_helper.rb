require 'spork'

ENV['RAILS_ENV'] ||= 'test'

Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  # trap mongoid
  require "rails/mongoid"
  Spork.trap_class_method(Rails::Mongoid, :load_models)

  # trap devise
  require 'rails/application'
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  # Prevent main application to eager_load in the prefork block (do not load files in autoload_paths)
  Spork.trap_method(Rails::Application, :eager_load!)

  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'

  Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec

    config.include Mongoid::Matchers
    config.include Devise::TestHelpers, type: :controller
    config.extend ControllerMacros, type: :controller
    config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'


    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = 'mongoid'
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  Fabrication.clear_definitions
end