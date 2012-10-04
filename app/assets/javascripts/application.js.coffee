#= require libraries
#= require_self
#= require_tree ./lib
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.App = new Backbone.Marionette.Application(
  Models: {}
  Collections: {}
  Controllers: {}
  Routers: {}
  Views: {
    Albums: {}
    Categories: {}
    Images: {}
    Containers: {}
  }
)

App.addRegions
  content: "#content"

App.addInitializer (options) ->
  for model in App.Models then model.setup()
  App.currentUser = new App.Models.User(options.currentUser)
  new App.Routers.AlbumsRouter(albums: options.albums)
  App.handleHistory()
