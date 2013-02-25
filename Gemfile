source 'https://rubygems.org'

gem 'rails', '~> 3.2'

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

gem 'responders'
gem 'simple_form'
gem 'draper'
gem 'decorates_before_rendering'
gem 'multi_fetch_fragments'

gem 'rack-contrib'
gem 'soulmate', require: 'soulmate/server'

gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'jquery-fileupload-rails'

gem 'zipruby'
gem 'sidekiq'
gem 'redis-objects', require: 'redis/list'

gem 'pry-rails'

group :development do
  gem 'thin'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rb-fsevent', require: false # OSX
  # gem 'rb-inotify', require: false # Linux
  # gem 'rb-fchange', require: false # Windows
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
end

group :development, :test do
  gem 'rspec-rails'
  gem 'fabrication'
  gem 'ffaker'
  gem 'spork-rails'
end

# Uncomment this to run script/sidekiq_web
# group :sidekiq_web do
#   gem 'slim'
#   gem 'sinatra'
# end

# Uncomment this and run bundle if you need to run the importer.
# After your done using the importer make sure to comment this block out
# again and run `bundle` or you may run into issues.
# group :importer do
#   gem 'dm-core'
#   gem 'dm-mysql-adapter'
#   gem 'progressbar'
#   gem 'dm-aggregates'
# end
