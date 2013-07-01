ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f }

RSpec.configure do |config|
  config.mock_with   :rspec
  config.expect_with(:rspec) {|c| c.syntax = :expect }

  config.include Devise::TestHelpers, type: :controller
  config.extend  ControllerMacros,    type: :controller
  config.include Haml::Helpers,       type: :helper

  config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |group|
    unless group.example.metadata[:no_database_cleaner]
      DatabaseCleaner.start
    end
  end

  config.before(:each, type: :helper) { init_haml_helpers }

  config.after(:each) do |group|
    metadata = group.example.metadata
    if metadata[:no_database_cleaner] && metadata[:capybara_feature]
      DatabaseCleaner.clean_with(:truncation)
    else
      DatabaseCleaner.clean
    end
  end
end
