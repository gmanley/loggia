class App.Routers.AlbumsRouter extends Backbone.Router
  initialize: (options) ->
    @albums = options.albums

  routes:
    'album/new'       : 'newAlbum'
    'albums/:id/edit' : 'edit'
    'albums/:id'      : 'show'

  newAlbum: ->
    @view = new App.Views.Albums.NewView(collection: @albums)
    $("#content").html(@view.render().el)

  show: (id) ->
    album = @albums.get(id)
    album.fetch(
      success: (model, response) =>
        @view = new App.Views.Albums.ShowView(model: model)
        $("#content").html(@view.render().el)
        @view.initializeUploader()
    )

  edit: (id) ->
    album = @albums.get(id)
    @view = new App.Views.Albums.EditView(model: album)
    $("#content").html(@view.render().el)
