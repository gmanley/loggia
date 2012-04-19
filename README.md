Soshigal
========

Soshigal is a photo gallery built with Rails.

[![Build Status](https://secure.travis-ci.org/gmanley/soshigal.png?branch=master)](http://travis-ci.org/gmanley/soshigal)

Features
-------

* Drag and Drop Image Uploading
* Simultaneous Uploading of Images
* Ajax Image Updating after Upload
* Nested Categories & Albums
* Basic Admin Role Based Permissions

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

* Ruby (>= 1.9.2)
* MongoDB
* Graphicsmagick (ie. `brew install graphicsmagick` on OSX)
* Bundler
* A Javascript Runtime - For Rails asset pipeline (Builtin on OSX / Install node on other OSes)

__Steps:__

1. Clone repository
2. CD into the app directory
2. `bundle install`
3. `rake db:seed`
4. `bundle exec rails server`
5. Login with the seed admin user (See Below).

#### Admin User: ####
    Email: admin@example.com
    Password: password 