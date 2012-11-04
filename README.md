Soshigal
========

Soshigal is a photo gallery built with Rails.

[![Build Status](https://secure.travis-ci.org/gmanley/soshigal.png?branch=master)](http://travis-ci.org/gmanley/soshigal)

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
* [MongoDB](http://www.mongodb.org) (Document-oriented NoSQL Database)
* [Mongoid](http://mongoid.org) (Object-Document-Mapper)
* [jQuery](http://jquery.com) (Javascript Framework)
* [HAML](http://haml-lang.com) (Markup)
* [Carrierwave](https://github.com/jnicklas/carrierwave) (Rails File Uploading)
* [Twitter Bootstrap](http://twitter.github.com/bootstrap) (Base CSS/Design)

Setup
-----
__Requirements:__

* Ruby (>= 1.9.3)
* MongoDB (>= 2)
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

Copyright 2012 [Grayson Manley](https://github.com/gmanley)