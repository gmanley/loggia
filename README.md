Loggia
========

Loggia is a photo gallery built with Rails.

[![Build Status](https://travis-ci.org/gmanley/loggia.png?branch=master)](https://travis-ci.org/gmanley/loggia)
[![Code Climate](https://codeclimate.com/github/gmanley/loggia.png)](https://codeclimate.com/github/gmanley/loggia)

Features
-------

* Drag and drop image uploading
* Simultaneous uploading of images
* Nested albums
* Basic admin role based permissions
* Commenting and favoriting of albums

To Do
-----
* More tests!

How?
----
Here is a list of some key components used in the application:

* [Rails](http://rubyonrails.org) (Web framework)
* [Postgresql](http://www.postgresql.org) (Object-relational database)
* [jQuery](http://jquery.com) (Javascript framework)
* [HAML](http://haml-lang.com) (Markup)
* [Carrierwave](https://github.com/jnicklas/carrierwave) (Rails file uploading)
* [Twitter Bootstrap](http://twitter.github.com/bootstrap) (Base CSS/design)

Setup
-----
__Requirements:__

* Ruby (>= 1.9.3)
* Postgresql (SQLite or MySQL will work to an extent as well)
* Graphicsmagick (ie. `brew install graphicsmagick` on OSX)
* Bundler
* A Javascript Runtime - For Rails asset pipeline (Builtin on OSX / Install node on other OSes)

__Steps:__

1. Clone repository
2. `cd` into the app directory
2. `bundle install`
3. `rake db:seed`
4. `bundle exec rails server`
5. Login with the seed users below.

#### Admin User: ####
    Email: admin@example.com
    Password: password

#### Regular User: ####
    Email: user@example.com
    Password: password

License
-------
Licensed under the [MIT License](http://creativecommons.org/licenses/MIT/)

Copyright 2013 [Grayson Manley](https://github.com/gmanley)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/gmanley/loggia/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

