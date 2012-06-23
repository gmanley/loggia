App.Views.Categories ||= {}

class App.Views.Categories.ShowView extends Backbone.View
  template: JST["app/templates/categories/show"]

  events:
    'click [data-action=destroy]': 'destroy'

  addAll: () =>
    for child in @model.children()
      @addOne(child)

  addOne: (child) =>
    if child.get('type')?
      switch child.get('type')
        when 'Category'
          view = new App.Views.Categories.CategoryView(model: child)
        when 'Album'
          view = new App.Views.Albums.AlbumView(model: child)
      @$('.thumbnails').append(view.render().el)

  render: ->
    App.albumsRouter = new App.Routers.AlbumsRouter(albums: @model.albums)
    @$el.html(@template(@model.toJSON()))
    @addAll()
    this