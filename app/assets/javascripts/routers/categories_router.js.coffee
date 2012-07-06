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
    category = @categories.get(id)
    category.fetch(
      success: (model, response) =>
        @view = new App.Views.Categories.ShowView(model: category)
        App.albumsRouter.albums = model.get('albums')
        $('#content').html(@view.render().el)
    )

  edit: (id) ->
    category = @categories.get(id)
    @view = new App.Views.Categories.EditView(model: category)
    $('#content').html(@view.render().el)