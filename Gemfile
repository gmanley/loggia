source :rubygems

gem 'rails', '~> 3.2'

gem 'rake'

gem 'haml-rails'
gem 'coffee-filter'
gem 'coffeebeans'

group :assets do
  gem 'sass-rails',     '~> 3.2'
  gem 'bootstrap-sass', '~> 2.2.1.1'
  gem 'coffee-rails',   '~> 3.2'
  gem 'uglifier'
  gem 'haml_coffee_assets'
  gem 'execjs'
end

gem 'jquery-rails'

gem 'pg'
gem 'stringex'
gem 'closure_tree'
gem 'squeel'

gem 'kaminari'

gem 'devise'
gem 'cancan', git: 'git://github.com/ryanb/cancan.git'

gem 'responders'
gem 'simple_form'
gem 'draper'
gem 'decorates_before_rendering'

gem 'carrierwave'
gem 'mini_magick', git: 'git://github.com/gmanley/mini_magick.git', branch: 'graphicsmagick-fix'
gem 'fog'
gem 'jquery-fileupload-rails'

gem 'zipruby'
gem 'archive-zip'
gem 'sidekiq'

gem 'pry-rails'

group :development do
  gem 'thin'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'launchy'
  gem 'quiet_assets'
  gem 'newrelic_rpm'
  gem 'bullet'
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
  gem 'spork-rails', git: 'git://github.com/gmanley/spork-rails.git'
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
