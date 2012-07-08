class App.Views.Categories.ShowView extends Backbone.View
  template: JST['templates/categories/show']

  events:
    'click [data-action=destroy]': 'destroy'
    'submit #new-album':           'createAlbum'
    'submit #new-category':        'createCategory'

  initialize: ->
    @model.get('albums')?.on('add', @addOne)
    @model.get('categories')?.on('add', @addOne)

  addAll: ->
    for child in @model.children()
      @addOne(child)

  addOne: (child) =>
    view = new App.Views.Containers.ContainerView(model: child)
    @$('.thumbnails').append(view.render().el)

  destroy: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.destroy().done =>
      @remove()
      Backbone.history.navigate('/', trigger: true)
      App.flashMessage('Category was successfully deleted.')

  createCategory: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless @categoryForm.commit()
      category = @categoryForm.model
      category.set(parent_id: @model.id)
      if @model.get('categories').create(category, wait: true)
        App.flashMessage('Category was successfully created.')

  createAlbum: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless @albumForm.commit()
      album = @albumForm.model
      album.set(parent_id: @model.id)
      if @model.get('albums').create(album, wait: true)
        App.flashMessage('Album was successfully created.')

  initForms: ->
    [html, @albumForm] = App.formsetFor('Album', legend: 'New Child Album')
    @$('#new-album').prepend(html)

    [html, @categoryForm] = App.formsetFor('Category', legend: 'New Child Category')
    @$('#new-category').prepend(html)

  render: ->
    @$el.html(@template(@model.toJSON()))
    @initForms()
    @addAll()
    this