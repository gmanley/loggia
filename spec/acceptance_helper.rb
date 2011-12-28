require 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join('spec/acceptance/support/**/*.rb')].each {|f| require f}

RSpec.configuration.include(Rails.application.routes.url_helpers, type: :request)
RSpec.configuration.include(Rails.application.routes.url_helpers, type: :acceptance)

Capybara.javascript_driver = :webkit