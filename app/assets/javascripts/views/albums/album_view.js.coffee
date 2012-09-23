class App.Views.Albums.AlbumView extends Backbone.View
  template: JST['templates/albums/_album']
  tagName: 'li'

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this
