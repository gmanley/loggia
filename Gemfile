source 'https://rubygems.org'

gem 'rails', '4.0.0'

gem 'pg', platform: :ruby # Postgresql Active Record adapters
gem 'activerecord-jdbcpostgresql-adapter', platform: :jruby
gem 'closure_tree' # Tree structures for your model (similar to acts_as_tree)
gem 'kaminari' # Pagination

gem 'jquery-rails' # Bundles jQuery and the UJS adapter for it
gem 'sass-rails', '~> 4.0.0' # Use SCSS for stylesheets
gem 'coffee-rails', '~> 4.0.0' # CoffeeScript support (.js.coffee)
gem 'haml_coffee_assets' # HAML coffeescript templates
gem 'bootstrap-sass', '~> 2.3.2.2' # SCSS version of bootstrap (usable mixins)
gem 'turbolinks' # PJAX-esque ajax links
gem 'jquery-turbolinks' # Better jQuery compatibility for turbolinks
gem 'haml-rails' # Adds HAML support along with custom generators
gem 'uglifier'

gem 'devise' # Authentication
gem 'cancan' # Authorization
gem 'activeadmin', github: 'gregbell/active_admin', branch: 'rails4' # Admin framework

gem 'carrierwave' # File uploading
gem 'mini_magick' # Image processing (rmagick alternative)
gem 'fog' # Cloud service ruby client (used by carrierwave for S3 support)
gem 'jquery-fileupload-rails' # jquery-fileupload assets and required middleware shim

gem 'responders', github: 'plataformatec/responders' # Customize respond_with behavior
gem 'simple_form', github: 'plataformatec/simple_form' # Better rails form helpers
gem 'multi_fetch_fragments' # Speeds up collection partial rendering
gem 'soulmate', require: 'soulmate/server' # Autocomplete endpoint using Redis
gem 'rack-contrib' # Needed by soulmate
gem 'stringex' # Various string helpers... used in slug generation

gem 'zipruby' # C extensions for libzip (Has bad memory leaks)
gem 'redis-objects', require: 'redis/list' # Ruby data types to redis mapping

gem 'sidekiq' # Background jobs
gem 'sidekiq-failures' # Adds a way to monitor worker failures
gem 'sinatra', require: nil # Needed for sidekiq monitoring
gem 'slim' # Ditto

gem 'pry-rails' # Replaces regular rails console with a pry session

group :development do
  gem 'puma' # Ruby app server
  gem 'guard' # Trigger tasks on file system events
  gem 'guard-rspec' # Allows for autotest like functionality
  gem 'ruby_gntp' # Cross-platform growl notification triggering from ruby
  gem 'launchy' # Cross-platform launching of applications from ruby
  gem 'quiet_assets' # Filters out static file serving logging
  gem 'newrelic_rpm' # Performance monitoring in development (/newrelic in browser)
  gem 'bullet' # Warns about n+1 queries and unused eager loading
  gem 'better_errors' # Amazing replacement of default rails error page
  gem 'binding_of_caller', platform: :ruby # Needed by better_errors for enhanced functionality
end

group :test do
  gem 'capybara' # Acceptance test framework
  gem 'database_cleaner', github: 'bmabey/database_cleaner' # Database cleaning for better test isolation
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers' # Collection of helpful rspec macros
  gem 'simplecov', require: false # Code coverage tool
  gem 'poltergeist' # Headless browser for capybara (uses PhantomJS)
end

group :development, :test do
  gem 'rspec-rails' # Test framework
  gem 'fabrication' # Fixtures replacement
  gem 'ffaker' # Test data generation
end
