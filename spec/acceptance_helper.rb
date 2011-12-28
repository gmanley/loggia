require 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join('spec/acceptance/support/**/*.rb')].each {|f| require f}

Capybara.default_driver = :selenium