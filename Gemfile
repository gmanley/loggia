source :rubygems

gem 'rails', git: 'https://github.com/rails/rails.git', branch: '3-2-stable'

gem 'haml-rails'
gem 'coffee-filter'
gem 'coffeebeans'

group :assets do
  gem 'sass-rails', git: 'https://github.com/rails/sass-rails.git', branch: '3-2-stable'
  gem 'coffee-rails', git: 'https://github.com/rails/coffee-rails.git', branch: '3-2-stable'
  gem 'uglifier'
end

gem 'jquery-rails', git: 'git://github.com/rails/jquery-rails.git'

gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'bson_ext'
gem 'mongoid_slug'
gem 'kaminari', git: 'git://github.com/amatsuda/kaminari.git'

gem 'devise'
gem 'cancan'

gem 'carrierwave', git: 'git://github.com/jnicklas/carrierwave.git'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'carrierwave_backgrounder'
gem 'mini_magick'
gem 'fog'

gem 'delayed_job'
gem 'delayed_job_mongoid' # Make sure to run: script/rails runner 'Delayed::Backend::Mongoid::Job.create_indexes'

group :development do
  gem 'itslog'
  gem 'foreman'
  gem 'guard'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'mongoid-rspec', git: 'git://github.com/evansagge/mongoid-rspec.git'
end

group :development, :test do
  gem 'rspec-rails',  '~> 2.8.0.rc'
  gem 'fabrication'
  gem 'ffaker'
  gem 'spork', '~> 0.9.0.rc'
end

# Unccomment this and run bundle if you need to run the importer.
# Make sure to comment it again and bundle after your done or you will run into issues.
# group :importer do
#   gem 'dm-core'
#   gem 'dm-mysql-adapter'
#   gem 'progressbar'
# end
