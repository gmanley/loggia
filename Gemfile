source :rubygems

gem 'rails', '~> 3.2'

gem 'rake'

gem 'haml-rails'
gem 'coffee-filter'
gem 'coffeebeans'

group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier'
  gem 'haml_coffee_assets'
  gem 'execjs'
end

gem 'jquery-rails'

gem 'mongoid'
gem 'stringex'
gem 'mongoid-tree'

gem 'kaminari'

gem 'devise'
gem 'cancan'

gem 'responders'
gem 'simple_form'

gem 'carrierwave'
gem 'carrierwave-mongoid', git: 'git://github.com/jnicklas/carrierwave-mongoid.git', branch: 'mongoid-3.0'
gem 'carrierwave-vips'
gem 'fog'

gem 'archive-zip'
gem 'sidekiq'

gem 'pry-rails'

group :development do
  gem 'thin'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'growl' # install growlnotify (http://growl.info/extras.php#growlnotify)
  gem 'launchy'
  gem 'quiet_assets'
  gem 'newrelic_rpm'
  gem 'newrelic_moped'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'mongoid-rspec'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'fabrication'
  gem 'ffaker'
  gem 'spork-rails'
end

# Unccomment this and run bundle if you need to run the importer.
# After your done using the importer make sure to comment this block out
# again and run `bundle` or you may run into issues.
# group :importer do
#   gem 'dm-core'
#   gem 'dm-mysql-adapter'
#   gem 'progressbar'
#   gem 'parallel'
#   gem 'dm-aggregates'
# end
