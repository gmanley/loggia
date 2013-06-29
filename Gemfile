source 'https://rubygems.org'

gem 'actionpack',   '~> 3.2'
gem 'activerecord', '~> 3.2'
gem 'actionmailer', '~> 3.2'
gem 'bundler'

group :assets do
  gem 'sass-rails',     '~> 3.2'
  gem 'bootstrap-sass', '~> 2.3.0.1'
  gem 'uglifier'
  gem 'haml_coffee_assets'
  gem 'execjs'
  gem 'turbo-sprockets-rails3'
end

gem 'coffee-rails',   '~> 3.2'
gem 'haml-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'

gem 'pg'
gem 'stringex'
gem 'closure_tree'
gem 'squeel'

gem 'kaminari'

gem 'devise'
gem 'cancan', github: 'ryanb/cancan'
gem 'activeadmin', github: 'gregbell/active_admin'

gem 'responders'
gem 'simple_form'
gem 'multi_fetch_fragments'

gem 'rack-contrib'
gem 'soulmate', require: 'soulmate/server'

gem 'carrierwave'
gem 'mini_magick'
gem 'nokogiri', '~> 1.5.9'
gem 'fog', '~> 1.12.1'
gem 'jquery-fileupload-rails'

gem 'zipruby'
gem 'redis-objects', require: 'redis/list'

gem 'sidekiq', require: %w[sidekiq sidekiq/web]
gem 'sidekiq-failures'
gem 'sinatra', require: nil
gem 'slim'

gem 'pry-rails'

group :development do
  gem 'thin'
  gem 'guard'
  gem 'guard-rspec'
  gem 'ruby_gntp'
  gem 'launchy'
  gem 'quiet_assets'
  gem 'newrelic_rpm'
  gem 'bullet'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'poltergeist'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'fabrication'
  gem 'ffaker'
end

# Uncomment this and run bundle if you need to run the importer.
# After your done using the importer make sure to comment this block out
# again and run `bundle` or you may run into issues.
# group :importer do
#   gem 'dm-core'
#   gem 'dm-mysql-adapter'
#   gem 'progressbar'
#   gem 'dm-aggregates'
# end
