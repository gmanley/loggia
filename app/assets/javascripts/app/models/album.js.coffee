class App.Models.Album extends Backbone.Model
  paramRoot: 'album'
  routingName: 'albums'

  initialize: (args) ->
    @images = new App.Collections.ImagesCollection()
    @images.category = this

  parse: (response) =>
    unless _.isUndefined(response.images)
      @images.add(response.images)
    delete response.images
    response

class App.Collections.AlbumsCollection extends Backbone.Collection
  model: App.Models.Album
  url: '/albums'
