App.Views.Albums ||= {}

class App.Views.Albums.EditView extends Backbone.View
  template : JST["app/templates/albums/edit"]

  events:
    "submit #edit-album" : "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (album) =>
        @model = album
        App.albumsRouter.navigate("/categories/#{album.id}", trigger: true)
    )

  render: ->
    @$el.html(@template(@model.toJSON()))
    @$('form').backboneLink(@model)
    this
