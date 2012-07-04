App.Views.Albums ||= {}

class App.Views.Albums.AlbumView extends Backbone.View
  template: JST['templates/containers/_container']
  tagName: 'li'

  destroy: ->
    @model.destroy()
    @remove()

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this