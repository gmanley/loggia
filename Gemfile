source 'https://rubygems.org'

gem 'rails', '4.0.0.rc1'

gem 'pg' # Postgresql Active Record adapter
# Tree structures for your model (similar to acts_as_tree)
gem 'closure_tree', github: 'gmanley/closure_tree', branch: 'rails4'
gem 'kaminari' # Pagination

gem 'jquery-rails' # Bundles jQuery and the UJS adapter for it
gem 'sass-rails',     '~> 4.0.0.rc1' # Use SCSS for stylesheets
gem 'coffee-rails',   '~> 4.0.0' # CoffeeScript support (.js.coffee)
gem 'uglifier',       '>= 1.3.0' # JavaScript compressor
gem 'haml_coffee_assets' # HAML coffeescript templates
gem 'execjs' # Wrapper around JS runtimes (required by haml_coffee_assets)
gem 'turbo-sprockets-rails3' # Speeds up asset precompilation
gem 'bootstrap-sass', '~> 2.3.1.0' # SCSS version of bootstrap (usable mixins)
gem 'turbolinks' # PJAX-esque ajax links
gem 'jquery-turbolinks' # Better jQuery compatibility for turbolinks
gem 'haml-rails' # Adds HAML support along with custom generators

gem 'devise', github: 'plataformatec/devise', branch: 'rails4' # Authentication
gem 'cancan' # Authorization
gem 'activeadmin', github: 'akashkamboj/active_admin', branch: 'rails4' # Admin framework
gem 'ransack', github: 'ernie/ransack', branch: 'rails-4' # Needed for activeadmin rails 4 support

gem 'carrierwave' # File uploading
gem 'mini_magick' # Image processing (rmagick alternative)
gem 'fog' # Cloud service ruby client (used by carrierwave for S3 support)
gem 'jquery-fileupload-rails' # jquery-fileupload assets and required middleware shim

gem 'responders' # Customize respond_with behavior
gem 'simple_form', github: 'plataformatec/simple_form' # Better rails form helpers
gem 'multi_fetch_fragments' # Speeds up collection partial rendering
gem 'soulmate', require: 'soulmate/server' # Autocomplete endpoint using Redis
gem 'rack-contrib' # Needed by soulmate
gem 'stringex' # Various string helpers... used in slug generation

gem 'zipruby' # C extensions for libzip (Has bad memory leaks)
gem 'sidekiq' # Background jobs
gem 'redis-objects', require: 'redis/list' # Ruby data types to redis mapping

gem 'pry-rails' # Replaces regular rails console with a pry session

group :development do
  gem 'thin' # Asynchronous ruby server
  gem 'guard' # Trigger tasks on file system events
  gem 'guard-rspec' # Allows for autotest like functionality
  gem 'ruby_gntp' # Cross-platform growl notification triggering from ruby
  gem 'launchy' # Cross-platform launching of applications from ruby
  gem 'quiet_assets' # Filters out static file serving logging
  gem 'newrelic_rpm' # Performance monitoring in development (/newrelic in browser)
  gem 'bullet' # Warns about n+1 queries and unused eager loading
  gem 'better_errors' # Amazing replacement of default rails error page
  gem 'binding_of_caller' # Needed by better_errors for enhanced functionality
end

group :test do
  gem 'capybara' # Acceptance test framework
  gem 'database_cleaner', github: 'bmabey/database_cleaner' # Database cleaning for better test isolation
  gem 'shoulda-matchers', github: 'gmanley/shoulda-matchers', branch: 'rails4' # Collection of helpful rspec macros
  gem 'simplecov', require: false # Code coverage tool
  gem 'poltergeist' # Headless browser for capybara (uses PhantomJS)
  gem 'faye-websocket', '0.4.7' # Used by poltergeist need to lock in version
end

group :development, :test do
  gem 'rspec-rails' # Test framework
  gem 'fabrication' # Fixtures replacement
  gem 'ffaker' # Test data generation
end
