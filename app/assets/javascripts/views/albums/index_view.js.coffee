class App.Views.Albums.IndexView extends Backbone.View
  template: JST['templates/albums/index']
  el: '#content'

  initialize: ->
    @collection.on('reset', @addAll)

  addAll: ->
    @collection.each (album) =>
      @addOne(album)

  addOne: (album) ->
    view = new App.Views.Albums.AlbumView(model: album)
    @$('.thumbnails').append(view.render().el)

  render: ->
    @$el.html(@template(albums: @collection.toJSON()))
    @addAll()
    this
