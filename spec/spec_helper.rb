require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'

  Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec

    config.include Mongoid::Matchers
    config.include Devise::TestHelpers, :type => :controller

    config.extend ControllerMacros, :type => :controller

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = 'mongoid'
    end

    config.before(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  Fabrication.clear_definitions
end

