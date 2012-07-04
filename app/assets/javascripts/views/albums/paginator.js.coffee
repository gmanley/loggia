class App.Views.Albums.PaginatorView extends Backbone.View
  className: "pagination pagination-centered"

  initialize: (options) ->
    @collection.on 'reset', @render

  render: ->
    @$el.html('<ul />')
    window.collection = @collection
    for i in [1..@collection.totalPages()]
      liClass = if i + 1 is @collection.page then " class='active'" else ''
      console.log "<li#{liClass}><a href='/#/albums/page/#{i}>#{i}</a></li>"
      @$('ul').append("<li#{liClass}><a href='/#/albums/page/#{i}>#{i}</a></li>")
    this