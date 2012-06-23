App.Views.Albums ||= {}

class App.Views.Albums.NewView extends Backbone.View
  template: JST["app/templates/albums/new"]

  events:
    "submit #new-album": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()
    @model.bind('change:errors', => @render())

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset('errors')

    @collection.create(@model.toJSON(),
      success: (album) =>
        @model = album
        App.albumsRouter.navigate("/albums/#{album.id}", trigger: true)

      error: (category, jqXHR) =>
        @model.set(errors: $.parseJSON(jqXHR.responseText))
    )

  render: ->
    @$el.html(@template(@model.toJSON()))
    @$('form').backboneLink(@model)
    this