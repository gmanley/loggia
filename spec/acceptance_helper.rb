require 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

Dir[Rails.root.join('spec/features/support/**/*.rb')].each {|f| require f }
RSpec.configure do |config|
  config.include(Rails.application.routes.url_helpers, type: :feature)
  config.include(HelperMethods, type: :feature)
end

Capybara.javascript_driver = :poltergeist
