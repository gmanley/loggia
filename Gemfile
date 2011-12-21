source :rubygems

gem 'rails', '~> 3.2.0.rc'

gem 'haml-rails'
gem 'coffee-filter'
gem 'coffeebeans'

group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier'
end

gem 'jquery-rails'

gem 'mongoid'
gem 'bson_ext'
gem 'mongoid_slug'
gem 'kaminari', :git => 'git://github.com/amatsuda/kaminari.git'

gem 'devise'
gem 'cancan'

gem 'carrierwave', :git => 'git://github.com/jnicklas/carrierwave.git'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'rack-gridfs', :git => 'git://github.com/skinandbones/rack-gridfs.git', :require => 'rack/gridfs'
gem 'mini_magick'

group :development do
  gem 'pry', :git => 'git://github.com/pry/pry.git'
  gem 'itslog'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'mongoid-rspec', :git => 'git://github.com/evansagge/mongoid-rspec.git'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'fabrication'
  gem 'ffaker'
  gem 'spork', '~> 0.9.0.rc'
end

group :importer do
  gem 'dm-core', :git => 'git://github.com/gmanley/dm-core.git'
  gem 'dm-do-adapter', :git => 'git://github.com/datamapper/dm-do-adapter.git'
  gem 'dm-mysql-adapter', :git => 'git://github.com/datamapper/dm-mysql-adapter.git'
  gem 'progressbar'
end