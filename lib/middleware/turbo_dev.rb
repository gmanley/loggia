# Extracted from http://git.io/HeGfdA
# Full credit to https://github.com/SamSaffron
#
# Middleware that causes static asset requests to bypass rails altogether. This
# can make requests a lot faster. From 4.5s to 1.5s in some apps. Only relevant
# in development environments as production already does this.
#
# Put this file in lib/middleware and add the following code to your
# development.rb environment file:
#
# config.middleware.insert 0, Middleware::TurboDev
#
# This will add the middleware to the top of the Rails middleware stack.

module Middleware
  class TurboDev

    def initialize(app, settings = {})
      @app = app
    end

    def call(env)
      if (etag = env['HTTP_IF_NONE_MATCH']) && env['REQUEST_PATH'] =~ %r[^/assets/]
        name = $'
        etag = etag.gsub '"', ''
        asset = Rails.application.assets.find_asset(name)

        if asset && asset.digest == etag
          return [304, {}, []]
        end
      end

      @app.call(env)
    end
  end
end
