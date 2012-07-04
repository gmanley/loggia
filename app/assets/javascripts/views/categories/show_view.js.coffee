App.Views.Categories ||= {}

class App.Views.Categories.ShowView extends Backbone.View
  template: JST['templates/categories/show']

  events:
    'click [data-action=destroy]': 'destroy'
    'submit #new-album':    'createAlbum'
    'submit #new-category': 'createCategory'

  initialize: ->
    @model.get('albums')?.on('add', @addOne)
    @model.get('categories')?.on('add', @addOne)

  addAll: ->
    for child in @model.children()
      @addOne(child)

  addOne: (child) ->
    if child.get('type')?
      switch child.get('type')
        when 'Category'
          view = new App.Views.Categories.CategoryView(model: child)
        when 'Album'
          view = new App.Views.Albums.AlbumView(model: child)
      @$('.thumbnails').append(view.render().el)

  destroy: ->
    @model.destroy()
    @remove()
    App.categoriesRouter.navigate('/', trigger: true)

  createCategory: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless @categoryForm.commit()
      category = @categoryForm.model
      category.set(parent_id: @model.id)
      @model.collection.create(category)

  createAlbum: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless @albumForm.commit()
      album = @albumForm.model
      album.set(parent_id: @model.id)
      @model.albums.create(album)

  initForms: ->
    [html, @albumForm] = App.formsetFor('Album', legend: 'New Child Album')
    @$('#new-album').prepend(html)

    [html, @categoryform] = App.formsetFor('Category', legend: 'New Subcategory')
    @$('#new-category').prepend(html)

  render: ->
    @$el.html(@template(@model.toJSON()))
    @initForms()
    @addAll()
    this