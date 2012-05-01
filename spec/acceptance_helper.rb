require 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join('spec/acceptance/support/**/*.rb')].each {|f| require f}
RSpec.configure do |config|
  config.include(Rails.application.routes.url_helpers, type: :acceptance)
  config.include(Rails.application.routes.url_helpers, type: :request)
  config.include(HelperMethods, type: :request)
  config.include(HelperMethods, type: :acceptance)
end
