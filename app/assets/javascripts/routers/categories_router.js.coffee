class App.Routers.CategoriesRouter extends Backbone.Router
  initialize: (options) ->
    App.categoriesRouter = this
    @categories = new App.Collections.CategoriesCollection()
    @categories.reset(options.categories)

  routes:
    '.*'                  : 'index'
    'categories/new'      : 'new'
    'categories/:id/edit' : 'edit'
    'categories/:id'      : 'show'

  new: ->
    @view = new App.Views.Categories.NewView(collection: @categories)
    $('#content').html(@view.render().el)

  index: ->
    @view = new App.Views.Categories.IndexView(collection: @categories)
    @view.render()

  show: (id) ->
    category = (@categories.get(id) || new App.Models.Category(id: id))
    category.fetch(
      success: (model, response) =>
        @view = new App.Views.Categories.ShowView(model: model)
        App.albumsRouter.albums = model.get('albums')
        $('#content').html(@view.render().el)
    )

  edit: (id) ->
    category = (@categories.get(id) || new App.Models.Category(id: id))
    category.fetch(
      success: (model, response) ->
        @view = new App.Views.Categories.EditView(model: model)
        $('#content').html(@view.render().el)
    )